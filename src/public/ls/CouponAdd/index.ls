let win = window, doc = document
	[getJSON] = [util.getJSON]

	_init-all-module = !->
		main 	 	= require "./mainManage.js"; 		main.initial!
		wx  		= require "./wxManage.js"; 			wx.initial!


	_main-init = (result)->
		_init-all-module!

	_main-init!

