
var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.send('success');
});

router.get('/login', function(req, res, next) {
    var sessionId = req.cookies.sessionId;
    if (sessionId != null || sessionId != undefined) {
        res.send({
            err_code: 10001,
            err_msg: '重复登录',
            err_notification_type: 1
        });
    } else {
        res.cookie('sessionId', 'session-id-u-12345678');
        res.status(200);
        res.send({
            result: {
                imToken : 'im-token-12345678'
            }
        });
    }
});

module.exports = router;