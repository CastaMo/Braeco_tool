wx-manage = let
	_state = null

	_add-card-by-config-options = (options)!->
		if typeof wx is "undefined" then return
		wxConfigFailed = false
		wx.config {
			debug 		: 		true
			app-id 		:			options.wxsign.appid
			timestamp : 		options.wxsign.timestamp
			nonce-str : 		options.wxsign.noncestr
			signature : 		options.wxsign.signature
			jsApiList : 		['addCard', 'openCard', 'chooseCard']
		}

		wx.ready !->
			if wxConfigFailed then return
			_add-card options

		wx.error (res)!->
			wxConfigFailed 	:= true
			innerCallback "fail", error("wx_config_error", res.errMsg)


	_add-card = (options)!->
		wx.add-card {
			card-list 	: 	[{
				card-id 	: 	options.card-info.id
				card-ext 	: 	options.card-info.json
			}]
			success 		: 	(res)!-> alert "已添加: #{JSON.stringify(res.card-list)}"
			cancel 			: 	(res)!-> alert JSON.stringify res
		}

	innerCallback = (result, err)->
		if typeof @_resultCallback is "function"
			if typeof err is "undefined" then err = @_error()
			@_resultCallback(result, err)

	initial: !->

	add-card: (options)!-> _add-card-by-config-options options

module.exports = wx-manage