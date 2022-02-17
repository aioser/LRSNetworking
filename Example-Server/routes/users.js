var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  var sessionId = req.cookies.sessionId;
  res.send({
    err_code: 10002,
    err_msg: '需要进行智能校验',
    err_notification_type: 0,
    err_params: {
      extVerificationType: 'sms,ntes',
      captcha: 'captcha-value',
      smsContent: 'sms-content',
      sessionId: sessionId
    }
  });
});

module.exports = router;
