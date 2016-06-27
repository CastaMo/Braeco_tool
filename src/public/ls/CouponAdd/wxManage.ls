wx-manage = let
	_state = null

	_add-card-by-config-options = (options, callback)!->
		if typeof wx is "undefined" then return
		wxConfigFailed = false
		wx.config {
			debug 		: 		false
			app-id 		:			options.wxsign.appid
			timestamp : 		options.wxsign.timestamp
			nonce-str : 		options.wxsign.noncestr
			signature : 		options.wxsign.signature
			jsApiList : 		['addCard', 'openCard', 'chooseCard']
		}

		wx.ready !->
			if wxConfigFailed then return
			_add-card options, callback

		wx.error (res)!->
			wxConfigFailed 	:= true
			innerCallback "fail", error("wx_config_error", res.errMsg)


	_add-card = (options, callback)!->
		wx.add-card {
			card-list 	: 	[{
				card-id 	: 	options.card-info.id
				card-ext 	: 	options.card-info.json
			}]
			success 		: 	(res)!-> callback res
			cancel 			: 	(res)!-> callback res
			fail 				: 	(res)!-> callback res
		}

	innerCallback = (result, err)->
		if typeof @_resultCallback is "function"
			if typeof err is "undefined" then err = @_error()
			@_resultCallback(result, err)

	initial: !->

	add-card: (options, callback)!-> _add-card-by-config-options options, callback

module.exports = wx-manage