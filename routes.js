const {
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
    FinishMission,
    completeDailyMission
    
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
        path: '/calories/{user_id}/{date}',
        handler: getDailyCalories
    },
    {
        method: 'POST',
        path: '/submission',
        handler: submission
    },
    {
        method: 'POST',
        path: '/startmission',
        handler: StartMission
    },
    {
        method: 'POST',
        path: '/finishmission',
        handler: FinishMission
    },
    {
        method: 'POST',
        path: '/daily-mission/complete',
        handler: completeDailyMission
    },
];

module.exports = routes;