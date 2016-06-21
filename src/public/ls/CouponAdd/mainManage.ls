wx = null

[			addListener] = 
	[		util.addListener]

main-manage = let

	_btn-dom 					= $ ".confirm-btn"

	_hide-JSON-dom 		= $ "\#hide-JSON"

	_coupon-options 	= null

	_init-all-Data = !->
		_coupon-options := JSON.parse(_hide-JSON-dom.html!).data
		console.log _coupon-options

	_init-depend-module = !->
		wx := require "./wxManage.js"

	_init-all-event = !->
		_btn-dom.click !-> wx.add-card _coupon-options

	initial: !->
		_init-all-Data!
		_init-depend-module!
		_init-all-event!

module.exports = main-manage