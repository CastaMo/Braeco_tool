var express = require('express');
var app = express();
var router = express.Router();
var renew = require('../renew');

module.exports = function(passport) {

    router.get('/', function(req, res) {
        res.redirect('/pay/wx/l4ng7cula0vbviejxt65wc2a5r2nz9rk');
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

    router.post('/pay/wx/:code', function(req, res) {
        res.json({ "message": "success", "order_id": "10020", "noncestr": "nwf1o0tzifg6xaxraemxvscxb60hsztf", "jsapi_ticket": "kgt8ON7yVITDhtdwci0qeXBFNEBq3JZ4fAHIc4wbw88gXg2cal4cDJFQCf_o9NEeR0dNhky5WYBCMs2UnFnpLA", "timestamp": 1463984022, "appid": "wx862323dac42227a9", "signtype": "MD5", "package": "prepay_id=wx201605231413440669086f400188344783", "signMD": "AA3443B48B0318C286652A496F981342", "signature": "39f5ce6dc32fdf2367b3cf135f3d15e736f099c2" });
    });


    router.get('/renew', function(req, res) {
        renew.renew(res);
    });


    router.post('/Category/Add', function(req, res) {
        res.json({
            message: "success",
            id: Number(Math.floor(100000 + Math.random() * 100000))
        });
    });

    router.post('/Category/Remove', function(req, res) {
        res.json({
            message: "success"
        });
    });

    router.post('/Category/Update/Profile', function(req, res) {
        res.json({
            message: "success"
        });
    });


    router.post('/Category/Update/Top/:id', function(req, res) {
        res.json({
            message: "success"
        });
    });

    router.post('/pic/upload/token/category/:id', function(req, res) {
        res.json({
            message: "success",
            key: 100,
            token: "heihei"
        });
    });

    return router;
};