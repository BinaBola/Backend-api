const createConnection = require("./dbhandler");
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const axios = require('axios');
require('dotenv').config();


const register = async (request, h) => {
    const { username, email, password, role, name, height, weight, birth_date, gender } = request.payload;
    const connection = await createConnection();

    const calculateCalories = (height, weight, age, gender) => {
        if (gender === 'L') {
            return 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age);
        } else if (gender === 'P') {
            return 447.6 + (9.2 *  weight) + (3.1 * height) - (4.3 * age);
        }
        return null;
    };

    try {
        if (!username || !email || !password || !role || !name || !height || !weight || !birth_date || !gender) {
            return h.response({ message: 'All fields are required' }).code(400);
        }

        const [emailrows] = await connection.execute('SELECT email FROM users WHERE email = ?', [email]);
        if (emailrows.length > 0) {
            return h.response({ message: 'Email already registered' }).code(400);
        }
        const [usernamerows] = await connection.execute('SELECT username FROM users WHERE username = ?', [username]);
        if (usernamerows.length > 0) {
            return h.response({ message: 'Username already registered' }).code(400);
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const today = new Date();
        const birthDate = new Date(birth_date);
        let age = today.getFullYear() - birthDate.getFullYear(); // Ubah dari const ke let
        const monthDiff = today.getMonth() - birthDate.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }

        const calorie = calculateCalories(height, weight, age, gender);

        console.log(`Registering user with birth_date: ${birth_date}`); // Logging for debugging

        const [result] = await connection.execute(
            'INSERT INTO users (username, email, password, created_at, role, name, height, weight, birth_date, gender, calorie) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [username, email, hashedPassword, new Date(), role, name, height, weight, birth_date, gender, calorie]
        );

        return h.response({ message: 'User registered successfully', user_id: result.insertId }).code(201);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};



const login = async (request, h) => {
    const { email, password } = request.payload;
    const connection = await createConnection();

    try {
        const [rows] = await connection.execute('SELECT * FROM users WHERE email = ?', [email]);
        if (rows.length === 0) {
            return h.response({ message: 'Invalid Email' }).code(401);
        }
        const user = rows[0];
        const isValidPassword = await bcrypt.compare(password, user.password);
        if (!isValidPassword) {
            return h.response({ message: 'Wrong Password' }).code(401);
        }

        const token = jwt.sign({ id: user.id, email: user.email, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1h' });

        const response = h.response({
            message: `Login Successfully. Welcome ${user.username}!`,
            user_id: user.id,
            token: token
        }).code(200);

        // Send a request to keep Cloud Run active after sending the response
        setImmediate(async () => {
            const cloudRunUrl = process.env.CLOUD_RUN; // Ganti dengan URL Cloud Run Anda
            try {
                await axios.get(cloudRunUrl);
                console.log("Cloud Run ping successful");
            } catch (error) {
                console.error("Error pinging Cloud Run:", error.message);
            }
        });

        return response;

    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};

const requestPasswordReset = async (request, h) => {
    const {email} = request.payload;
    const connection = await createConnection();

    try {
        const [rows] = await connection.execute('SELECT id FROM users WHERE email = ?', [email]);
        if (rows.length === 0) {
            return h.response({message : 'Email Not Found' }).code(404);
        }
        const userId = rows[0].id;
        const token = crypto.randomBytes(20).toString('hex');
        const expires = new Date(Date.now() + 3600000);

        await connection.execute(
            'INSERT INTO password_resets (user_id, token, expires) VALUES (?, ?, ?)',
            [userId, token, expires]
        );

        const pengirim = nodemailer.createTransport({
            service:'gmail',
            secure:true,
            logger:false,
            debug:true,
            secureConnection:false,
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
            tls:{
                rejectUnauthorized:true
            }
        });
        const mailOptions = {
            from : process.env.EMAIL_USER,
            to : email,
            subject: 'Password Reset Request',
            text: `You are receiving this because you (or someone else) have requested the reset of the password for your account. Please Copy an paste this into our application to complete the process:
                   \n${token}\n
                   If you did not request this, please ignore this email and your password will remain unchanged.`,
            html: `<p>You are receiving this because you (or someone else) have requested the reset of the password for your account. Please copy and paste this into our application to complete the process:</p>
                   <p>${token}</p>
                   <p>If you did not request this, please ignore this email and your password will remain unchanged.</p>
                   <a href="https://www.youtube.com/"><button>Reset Button</button></a>`,
        };
        await pengirim.sendMail(mailOptions);

        return h.response({ message: 'Password reset email sent' }).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};

const resetPassword = async (request, h) => {
    const { token, newPassword } = request.payload;
    const connection = await createConnection();
    
    try {
        const [rows] = await connection.execute('SELECT user_id, expires FROM password_resets WHERE token = ?', [token]);
        if (rows.length === 0) {
            return h.response({ message: 'Invalid or expired token' }).code(400);
        }

        const resetRequest = rows[0];

        if (new Date() > resetRequest.expires) {
            return h.response({ message: 'Token expired' }).code(400);
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);

        await connection.execute(
            'UPDATE users SET password = ? WHERE id = ?',
            [hashedPassword, resetRequest.user_id]
        );

        await connection.execute(
            'DELETE FROM password_resets WHERE token = ?',
            [token]
        );

        return h.response({ message: 'Password reset successfully' }).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error!' }).code(500);
    } finally {
        connection.end();
    }
};

const getExercise = async (request, h) => {
    const { id } = request.params;
    const today = new Date().toISOString().split('T')[0];
    const { user_id, exercise_id } = request.query; // Asumsikan user_id dan exercise_id didapatkan dari query parameter
    const connection = await createConnection();

    try {
        // Query untuk mendapatkan exercise
        const [exerciseRows] = await connection.execute(
            'SELECT id, name, detail, category, step, calorie_out, foto, video, body_part_needed, is_support_interactive, interactive_setting_id, interactive_body_part_segment_value_id, submission FROM exercises WHERE id = ?', [id]
        );
        
        if (exerciseRows.length === 0) {
            return h.response({ message: 'Exercise not found' }).code(404);
        }

        // Query untuk mendapatkan status dari daily_missions
        const [statusRows] = await connection.execute(
            'SELECT status FROM daily_missions WHERE user_id = ? AND exercise_id = ? AND date = ?', [user_id, exercise_id, today]
        );

        let status = 0; // Default status
        if (statusRows.length > 0 && statusRows[0].status === 1) {
            status = 1;
        } else if (statusRows.length > 0 && statusRows[0].status === 2) {
            status = 2;
        }

        // Query untuk mendapatkan video_url dari submission
        const [submissionRows] = await connection.execute(
            'SELECT video_url FROM submission WHERE user_id = ? AND exercise_id = ? AND date = ?', [user_id, exercise_id, today]
        );

        let video_url = null;
        if (submissionRows.length > 0) {
            video_url = submissionRows[0].video_url;
        }

        // Menggabungkan hasil query exercise, status, dan video_url
        const result = {
            ...exerciseRows[0],
            status: status,
            video_url: video_url
        };

        return h.response(result).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};



const getAllExercise = async (request, h) => {
    const { category } = request.query;
    const connection = await createConnection();

    try {
        let query = 'SELECT id, name, duration, category, calorie_out, foto FROM exercises';
        let params = [];
        if (category) {
            query += ' WHERE category = ?';
            params.push(category);
        }

        const [rows] = await connection.execute(query, params);
        return h.response(rows).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};


const getDetailUser = async (request, h) => {
    const { id } = request.params;
    const connection = await createConnection();

    try {
        const [rows] = await connection.execute('SELECT id, name, height,  weight, birth_date, gender, calorie FROM users WHERE id = ?', [id]);
        if (rows.length === 0) {
            return h.response({ message: 'User not found' }).code(404);
        }
        return h.response(rows[0]).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};

const addCalories = async (request, h) => {
    const { user_id, date, foods, calorie, amount, category } = request.payload;
    const total = calorie * amount; // Hitung total calorie

    const connection = await createConnection();

    try {
        // Simpan informasi submission ke dalam database
        await connection.execute(
            'INSERT INTO calories (user_id, date, foods, calorie, amount, category, total) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [user_id, date, foods, calorie, amount, category, total]
        );

        return h.response({ message: 'Calories are added successfully' }).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};


const getDailyCalories = async (request, h) => {
    const { user_id, date } = request.params;
    const connection = await createConnection();
    
    try {
        // Validasi input
        if (!user_id || !date) {
            return h.response({ message: 'User ID and date are required' }).code(400);
        }
    
        // Pilih semua kolom dari tabel
        const [rows] = await connection.execute('SELECT user_id, foods, category, total FROM calories WHERE user_id = ? AND date = ?', [user_id, date]);
        if (rows.length === 0) {
            return h.response({ message: 'No data found for this date' }).code(404);
        }
        return h.response(rows).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
}    
 

const submission = async (request, h) => {
    const { user_id, exercise_id, video_url } = request.payload;
    const today = new Date().toISOString().split('T')[0];
    const connection = await createConnection();

    try {
        // Simpan informasi submission ke dalam database
        await connection.execute(
            'INSERT INTO submission (user_id, exercise_id, video_url, date) VALUES (?, ?, ?, ?)',
            [user_id, exercise_id, video_url, today]
        );

        return h.response({ message: 'Submission with video link added successfully' }).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};

const StartMission = async (request, h) => {
    const { user_id, exercise_id} = request.payload;
    const today = new Date().toISOString().split('T')[0];
    const status = 1
    const connection = await createConnection();

    try {
        // Simpan informasi submission ke dalam database
        await connection.execute(
            'INSERT INTO daily_missions (user_id, exercise_id, date, status) VALUES (?, ?, ?, ?)',
            [user_id, exercise_id, today, status]
        );

        return h.response({ message: 'Daily mission is started' }).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};

const FinishMission = async (request, h) => {
    const { user_id, exercise_id } = request.payload;
    const today = new Date().toISOString().split('T')[0];
    const newStatus = 2; // Status yang akan diupdate

    const connection = await createConnection();

    try {
        // Update status daily mission ke '1'
        const [result] = await connection.execute(
            'UPDATE daily_missions SET status = ? WHERE user_id = ? AND exercise_id = ? AND date = ?',
            [newStatus, user_id, exercise_id, today]
        );

        if (result.affectedRows === 0) {
            return h.response({ message: 'Daily mission not found' }).code(404);
        }

        return h.response({ message: 'Daily mission status updated to completed' }).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};






module.exports = {
    register,
    login,
    requestPasswordReset,
    resetPassword,
    getExercise,
    getAllExercise,
    getDetailUser,
    addCalories,
    getDailyCalories,
    submission,
    StartMission,
    FinishMission
};