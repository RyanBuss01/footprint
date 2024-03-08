const sqlDB = require('../middleware/sql_connect')
const defaultAvatar = require('../constants/default_avatar.js')
const bcrypt = require('bcrypt');

var functions = {

    signup : async function(req, res) {
        console.log("run")
        console.log(req.body)
        var json = {
            email : req.body.email,
            password : req.body.password,
            firstName : req.body.firstName,
            lastName : req.body.lastName,
            username : req.body.username,
            displayName : req.body.displayName,
            birthday : req.body.birthday
        }

        const salt = await bcrypt.genSalt(10);
        var password = await bcrypt.hash(json.password, salt);

        var sql = `
            INSERT INTO footprint.User (email, firstName, lastName, displayName, avatar, password)
            VALUES (
                '${json.email}', 
                '${json.firstName}', 
                '${json.lastName}', 
                '${json.displayName}', 
                '${defaultAvatar}', 
                '${password}'
            )
            ON DUPLICATE KEY UPDATE 
			email = Values(email); 
            `;

        sqlDB.query(sql, function(err, result) {
            if(err)  {res.status(400).send(), console.log(err)}
            console.log(result)
            res.status(200).send({id : result.insertId})
        })
    },

    signin : async function (req, res) {
        let sql = `SELECT * FROM footprint.User WHERE email = '${req.body.email}'`;

        sqlDB.query(sql, async function (err, result) {

            if(err) {res.status(400), console.log(err)}
            if(result.length == 0) {res.status(204).send()}
            else {
                var userdata = result[0];

                const validPassword = await bcrypt.compare(req.body.password, userdata.password);
                if(validPassword) {res.status(200).send({user_id : userdata.id})}
                else {res.status(400).send({msg: 'invalid password'})}
            }
        })

        
    },

    getUserData : async function (req, res) {  
        var json = {
            id : Number(req.headers.id),
            myId : Number(req.headers.myid),
            username : req.headers.username
        }

        if(req.headers.querytype == 'byId') {
        let sql; 
        if(req.headers.isme == 'true') {
            sql = `
            SELECT User.id as user_id, User.username, User.displayName, User.bio, User.avatar
            FROM my_street.User 
            LEFT JOIN my_street.FriendRequest 
            ON FriendRequest.receiver = ${json.id}
            AND User.id = ${json.id}
            GROUP BY User.id
            LIMIT 1
            `;
        }
        else {
            sql = `
            SELECT User.id as user_id, User.displayName, User.bio, User.avatar, FriendRequest.receiver, FriendRequest.sender, Friends.status as friend_status, UserLocation.latitude, UserLocation.longitude, UserLocation.dt
            FROM my_street.User 
            LEFT JOIN my_street.UserLocation
            ON User.id = UserLocation.user_id
            LEFT JOIN my_street.Friends 
            ON Friends.user1_id = ${json.id} AND Friends.user2_id = ${json.myId} OR Friends.user1_id = ${json.myId} AND Friends.user2_id = ${json.id}
            LEFT JOIN my_street.FriendRequest 
            ON FriendRequest.sender = ${json.id} AND FriendRequest.receiver = ${json.myId} OR FriendRequest.receiver = ${json.id} AND FriendRequest.sender = ${json.myId}
            WHERE User.id = ${json.id}
        `
        }

        sqlDB.query(sql, function (err, result) {
            if(err) {res.status(200).send(), console.log(err)}
            var userdata = result[0];
            res.status(200).send(userdata)
        })
    }
    if(req.headers.querytype == 'byUsername') {
        let sql = `
        SELECT User.id as user_id, User.displayName, User.bio, User.avatar, FriendRequest.receiver, FriendRequest.sender, Friends.status, UserLocation.dt
        FROM my_street.User 
        LEFT JOIN my_street.Friends 
        ON Friends.user1_id = User.id AND Friends.user2_id = ${json.myId} OR Friends.user1Id = ${json.myId} AND Friends.user2Id = User.id
        LEFT JOIN my_street.FriendRequest 
        ON FriendRequest.sender = User.id AND FriendRequest.receiver = ${json.myId} OR FriendRequest.receiver = User.id AND FriendRequest.sender = ${json.myId}
        WHERE displayName = '${json.username}'
        `

        sqlDB.query(sql, function (err, result) {
            if(err) {res.status(200).send(), console.log(err)}
            var userdata = result[0];
            res.status(200).send(userdata)
        })
    }
    },

}

module.exports = functions;