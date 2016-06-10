require_ = wx = null

[			addListener] = 
	[		util.addListener]

main-manage = let

	_price-input-dom 		= $ "\#input-price"
	_clear-btn-dom 			= $ "\#key-clear"
	_confirm-btn-dom 		= $ "\#key-confirm"
	_main-container-dom = $ "\#main-container"
	_finish-amount-dom 	= $ ".Payment-container p.amount"

	_url 								= null
	_able 							= false

	_integer 						= "0"
	_dot 								= ""
	_decimal 						= ""

	_total-number 			= ""

	#1代表是整数输入，0代表是小数输入
	_state 							= 1


	_init-style = !->
		try
			if window.innerWidth then clientWidth = window.innerWidth
			else clientWidth =  document.body.clientWidth
		catch error
			alert "窗口初始化失败，请使用其他手机扫码支付"

		keyboard-width 	= clientWidth
		keyboard-height =	clientWidth * 250 / 375

		$ "\#Keyboard" .css {
			"width" 				:		"#{keyboard-width}px"
			"height" 				: 	"#{keyboard-height}px"
		}

		$ ".left-part .key-field > *:not(.clear)" .css {
			"line-height" 	: 	"#{keyboard-height / 4}px"
			"height" 				: 	"#{keyboard-height / 4}px"
		}

		$ ".right-part .key-field \#key-clear" .css {
			"line-height" 	: 	"#{keyboard-height / 4}px"
			"height" 				: 	"#{keyboard-height / 4}px"
		}

		$ ".right-part .key-field \#key-confirm" .css {
			"line-height" 	: 	"#{keyboard-height / 4 * 3}px"
			"height" 				: 	"#{keyboard-height / 4 * 3}px"
		}

		$ "\#Keyboard" .fade-in 200

	_init-all-Data = !->
		_url 		:= location.pathname.split("/").pop()

	_init-depend-module = !->
		require_ 	:= 		require "./requireManage.js"
		wx 				:= 		require "./wxManage.js"

	_init-all-event = !->
		
		addListener _clear-btn-dom[0], "touchstart", !-> _clear-input-event!; _price-input-change-callback!

		addListener _confirm-btn-dom[0], "touchstart" !-> _confirm-btn-click-event!

		addListener ($ "\#key-0")[0], "touchstart", !-> _zero-input-event!; _price-input-change-callback!

		addListener ($ "\#key-dot")[0], "touchstart", !-> _dot-input-event!; _price-input-change-callback!

		for let i in [1 to 9]
			addListener ($ "\#key-#{i}")[0], "touchstart", !-> _number-not-zero-input-event String(i); _price-input-change-callback!

	_zero-input-event = !->
		if _state
			if _integer.length >= 5 then return
			if _integer is "0" then return
			_integer += "0"
		else
			if _decimal.length >= 1 then return
			if _decimal is "" then _decimal := "0"

	_number-not-zero-input-event = (number)!->
		if _state
			if _integer.length >= 5 then return
			if _integer is "0" then _integer := number
			else _integer += number
		else
			if _decimal.length >= 2 then return
			_decimal += number

	_dot-input-event = !->
		_state 	:= 0
		_dot 		:= "."

	_clear-input-event = !->
		_integer 						:= "0"
		_dot 								:= ""
		_decimal 						:= ""
		_total-number 			:= ""
		_state 							:= 1

	_price-input-change-callback = !->
		_total-number := _integer + _dot + _decimal
		_price-input-dom.html _total-number
		if Number(_total-number) > 0 then _enable-btn!
		else _disable-btn!

	_confirm-btn-click-event = !->
		if _able
			_disable-btn!
			require_.get("weixinPay").require {
				data 			: 		_get-data-for-require!
				callback 	: 		(result)-> _success-callback-for-ajax result
				always 		: 		-> _price-input-change-callback!
			}

	_enable-btn = !->
		_confirm-btn-dom.remove-class "disabled"; _able := true

	_disable-btn = !->
		_confirm-btn-dom.add-class "disabled"; _able := false

	_get-data-for-require = ->
		data = {}; _r = {};
		_r.amount = Number(_total-number)
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

	_success-callback-for-weixin-pay = !->
		_main-container-dom.add-class "finish"
		_finish-amount-dom.html Number(_total-number)


	initial: !->
		_init-style!
		_init-all-Data!
		_init-depend-module!
		_init-all-event!

module.exports = main-manage