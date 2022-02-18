var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/info', function(req, res, next) {
  var captcha = req.headers.captcha;
  var sessionId = req.cookies.sessionId;
  console.log('captcha =>' + captcha);
  if (captcha == null || captcha == undefined) {
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
  } else {
    res.send({
      name: 'user-name-123'
    });
  }
  
});

module.exports = router;
