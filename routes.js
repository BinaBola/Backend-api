const {
    register,
    login,
    requestPasswordReset,
    resetPassword,
    getExercise,
    getAllExercise,
    getDetailUser,
    addCalories,
    getDailyCalories
    
} = require('./handler');

const routes = [
    {
        method: 'POST',
        path: '/register',
        handler: register
    },
    {
        method: 'POST',
        path: '/login',
        handler: login
    },
    {
        method: 'POST',
        path: '/requestpass',
        handler: requestPasswordReset
    },
    {
        method: 'POST',
        path: '/resetpass',
        handler: resetPassword
    },
    {
        method: 'GET',
        path: '/exercise/{id}',
        handler: getExercise
    },
    {
        method: 'GET',
        path: '/exercises',
        handler: getAllExercise
    },
    {
        method: 'GET',
        path: '/user/{id}',
        handler: getDetailUser
    },
    {
        method: 'POST',
        path: '/calories',
        handler: addCalories
    },
    {
        method: 'GET',
        path: '/calories',
        handler: getDailyCalories
    },
    {
        method: 'POST',
        path: '/exercise-results',
        handler: addExerciseResult
    },
    {
        method: 'GET',
        path: '/exercise-results/{user_id}',
        handler: getExerciseResults
    }
];

module.exports = routes;
