const express = require('express') 
const actions = require('../methods/actions')
const router = express.Router()

router.post('/signup', actions.signup)
router.post('/signin', actions.signin)
router.get('/getUserdata', actions.getUserData)
router.get('/getUserFog',  actions.getUserFog)



module.exports = router;