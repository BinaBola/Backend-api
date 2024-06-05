const createConnection = require("./dbhandler");
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
require('dotenv').config();


const register = async (request, h) => {
    const { username, email, password, role, nama, tb, bb, umur, gender } = request.payload;
    const connection = await createConnection();

    const calculateCalories = (tb, bb, umur, gender) => {
        if (gender === 'L') {
            return 88.36 + (13.4 * bb) + (4.8 * tb) - (5.7 * umur);
        } else if (gender === 'P') {
            return 447.6 + (9.2 * bb) + (3.1 * tb) - (4.3 * umur);
        }
        return null;
    };

    try {
        if (!username || !email || !password || !role || !nama || !tb || !bb || !umur || !gender) {
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
        const kalori = calculateCalories(tb, bb, umur, gender);

        const [result] = await connection.execute(
            'INSERT INTO users (username, email, password, created_at, role, nama_lengkap, tb, bb, umur, gender, kalori) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [username, email, hashedPassword, new Date(), role, nama, tb, bb, umur, gender, kalori]
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

        return h.response({
            message: `Login Successfully. Welcome ${user.username}!`,
            user_id: user.id,
            token: token
        }).code(200);

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
    const connection = await createConnection();

    try {
        const [rows] = await connection.execute('SELECT id, nama, detail, category, step, kalori_keluar, foto, video FROM exercises WHERE id = ?', [id]);
        if (rows.length === 0) {
            return h.response({ message: 'Exercise not found' }).code(404);
        }
        return h.response(rows[0]).code(200);
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
        let query = 'SELECT id, nama, category FROM exercises';
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
        const [rows] = await connection.execute('SELECT id, nama_lengkap, tb, bb, umur, gender, kalori FROM users WHERE id = ?', [id]);
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
    const { user_id, date, morning = 0, afternoon = 0, evening = 0 } = request.payload;
    const connection = await createConnection();

    try {
        const totalCalories = (morning || 0) + (afternoon || 0) + (evening || 0);

        // Check if entry already exists for the date
        const [rows] = await connection.execute('SELECT * FROM calories WHERE user_id = ? AND date = ?', [user_id, date]);
        if (rows.length > 0) {
            // Update existing entry
            await connection.execute(
                'UPDATE calories SET morning = ?, afternoon = ?, evening = ?, total_calories = ? WHERE user_id = ? AND date = ?',
                [morning, afternoon, evening, totalCalories, user_id, date]
            );
        } else {
            // Insert new entry
            await connection.execute(
                'INSERT INTO calories (user_id, date, morning, afternoon, evening, total_calories) VALUES (?, ?, ?, ?, ?, ?)',
                [user_id, date, morning, afternoon, evening, totalCalories]
            );
        }

        return h.response({ message: 'Calories added successfully' }).code(200);
    } catch (err) {
        console.error(err);
        return h.response({ message: 'Internal Server Error' }).code(500);
    } finally {
        connection.end();
    }
};


const getDailyCalories = async (request, h) => {
    const { user_id, date } = request.query;
    const connection = await createConnection();

    try {
        const [rows] = await connection.execute('SELECT * FROM calories WHERE user_id = ? AND date = ?', [user_id, date]);
        if (rows.length === 0) {
            return h.response({ message: 'No data found for this date' }).code(404);
        }
        return h.response(rows[0]).code(200);
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
    getDailyCalories
};
