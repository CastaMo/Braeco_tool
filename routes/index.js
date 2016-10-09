var express = require('express');
var app = express();
var router = express.Router();
var renew = require('../renew');

module.exports = function(passport) {

    router.get('/', function(req, res) {
        res.redirect('/location/manage/');
    });

    router.get('/pay/wx/Data', function(req, res) {
        setTimeout(function() {
            res.send("var allData = '" + '{"message":"success","data":{"wx":{"openid":123120123}}}' + "';" +
                "if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;allData = null;}");
        }, 0);
    });

    router.get('/pay/wx/:code', function(req, res) {
        res.render('./SimulatePay/develop');
    });

    router.get('/coupon/add/:code', function(req, res) {
        res.render('./CouponAdd/develop');
    });

    router.get('/location/select/', function(req, res) {
        res.render('./LocationSelect/develop');
    });

    router.get('/location/manage/', function(req, res) {
        res.render('./LocationManage/develop');
    });

    router.post('/pay/wx/:code', function(req, res) {
        res.json({ "message": "success", "order_id": "10020", "noncestr": "nwf1o0tzifg6xaxraemxvscxb60hsztf", "jsapi_ticket": "kgt8ON7yVITDhtdwci0qeXBFNEBq3JZ4fAHIc4wbw88gXg2cal4cDJFQCf_o9NEeR0dNhky5WYBCMs2UnFnpLA", "timestamp": 1463984022, "appid": "wx862323dac42227a9", "signtype": "MD5", "package": "prepay_id=wx201605231413440669086f400188344783", "signMD": "AA3443B48B0318C286652A496F981342", "signature": "39f5ce6dc32fdf2367b3cf135f3d15e736f099c2" });
    });

    return router;
};