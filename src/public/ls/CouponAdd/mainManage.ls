require_ = wx = null

[			addListener] = 
	[		util.addListener]

main-manage = let

	_btn-dom 					= $ ".confirm-btn"

	_hide-JSON-dom 		= $ "\#hide-JSON"

	_coupon-options 	= null

	_init-all-Data = !->
		_coupon-options := JSON.parse(_hide-JSON-dom.html!).data

	_init-depend-module = !->
		wx 				:= require "./wxManage.js"
		require_ 	:= require "./requireManage.js"

	_init-all-event = !->
		_btn-dom.click ->
			if _coupon-options.type is 0 then return window.location.href = "/Table/Home#-Home-Menu-x"
			wx.add-card _coupon-options, _success-callback

	_success-callback = (result)!->
		require_.get("couponAdd").require {
			data  	: 		{
				JSON 	:			JSON.stringify(result)
			}
			always 	:			(result)!-> window.location.href = "/Table/Home#-Home-Menu-x"
		}

	initial: !->
		_init-all-Data!
		_init-depend-module!
		_init-all-event!

module.exports = main-manage