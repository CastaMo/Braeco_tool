wx-manage = let
	/*_state = null

	callpay = (options)->
		self = @
		if typeof wx isnt "undefined"
			wxConfigFailed = false
			wx.config({
				debug:false
				appId:"#{options.appid}"
				timestamp:options.timestamp
				nonceStr:"#{options.noncestr}"
				signature: "#{options.signature}"
				jsApiList: ['chooseWXPay']
			})
			wx.ready ->
				if wxConfigFailed then return
				wx.chooseWXPay {
					timestamp: options.timestamp
					nonceStr: "#{options.noncestr}"
					package: "#{options.package}"
					signType: 'MD5'
					paySign: "#{options.signMD}"
					success: (res)->
						options.always?()
						if res.errMsg is "chooseWXPay:ok" then innerCallback("success"); options.callback?()
						else innerCallback("fail", error("wx_result_fail", res.errMsg))
					cancel: (res)-> options.always?(); innerCallback("cancel")
					fail: (res)-> options.always?(); innerCallback("fail", error("wx_config_fail", res.errMsg))
				}
			wx.error (res)-> options.always?(); wxConfigFailed = true; innerCallback("fail", error("wx_config_error", res.errMsg))

	innerCallback = (result, err)->
		if typeof @_resultCallback is "function"
			if typeof err is "undefined" then err = @_error()
			@_resultCallback(result, err)*/

	onBridgeReady = (options)->
		WeixinJSBridge.invoke(
			'getBrandWCPayRequest', {
				"appId": "#{options.appid}"
				"timeStamp": "#{options.timestamp}"
				"nonceStr": "#{options.noncestr}"
				"package": "#{options.package}"
				"signType": "#{options.signtype}"
				"paySign": "#{options.signMD}"
			},
			(res)->
				options.always?()
				if res.err_msg is "get_brand_wcpay_request:ok"
					options.callback?()
				else if res.err_msg is "get_brand_wcpay_request:fail"
					alert "支付失败, #{JSON.stringify(res)}"
		)

	initial: !->

	pay: (options) !-> onBridgeReady options

module.exports = wx-manage
