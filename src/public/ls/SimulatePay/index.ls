let win = window, doc = document
	[getJSON] = [util.getJSON]

	_init-all-module = !->
		main 	 	= require "./mainManage.js"; 		main.initial!
		require_ 	= require "./requireManage.js"; 	require_.initial!
		wx  		= require "./wxManage.js"; 			wx.initial!


	_main-init = (result)->
		_init-all-module!


	_main-init!

