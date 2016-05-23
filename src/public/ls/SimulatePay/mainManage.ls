require_ = wx = null
main-manage = let

	_open-id-dom 		= $ "\#hide-info \#wx"
	_price-input-dom 	= $ "input\#price"
	_tranfer-btn-dom 	= $ ".tranfer-btn"

	_open-id 			= null
	_url 				= null
	_able 				= false

	_init-all-Data = !->
		_url 		:= location.pathname.split("/").pop()
		_open-id 	:= Number _open-id-dom.html!
		_open-id-dom.parent!.remove!		

	_init-depend-module = !->
		require_ 	:= 		require "./requireManage.js"
		wx 			:= 		require "./wxManage.js"

	_init-all-event = !->
		_price-input-dom.keyup !-> _price-input-change-event!

		_tranfer-btn-dom.click !-> _tranfer-btn-click-event!

	_enable-btn = !->
		_tranfer-btn-dom.remove-class "disabled"; _able := true

	_disable-btn = !->
		_tranfer-btn-dom.add-class "disabled"; _able := false

	_get-data-for-require = ->
		data = {}; _r = {};
		_r.amount = _price-input-dom.val!
		data.JSON = JSON.stringify _r
		data.url = _url
		return data

	_success-callback-for-ajax = (result)!->
		wx.pay {
			appid: result.appid
			timestamp: result.timestamp
			noncestr: result.noncestr
			signature: result.signature
			package: result.package
			signMD: result.signMD
			callback: -> _success-callback-for-weixin-pay!
		}

	_success-callback-for-weixin-pay = !-> history.go(-1); alert "支付成功, 请关闭页面"; 


	_price-input-change-event = !->
		price = _price-input-dom.val!
		if price is "" then _disable-btn!
		else _enable-btn!

	_tranfer-btn-click-event = !->
		if _able
			_disable-btn!
			require_.get("weixinPay").require {
				data 		: 		_get-data-for-require!
				callback 	: 		_success-callback-for-ajax
				always 		: 		-> _price-input-change-event!
			}

	initial: !->
		_init-all-Data!
		_init-depend-module!
		_init-all-event!

module.exports = main-manage