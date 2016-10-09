let win = window, doc = document
	[getJSON] = [util.getJSON]


	_init-all-module = !->
		_data 		= JSON.parse($ "\#hide-JSON" .html!)
		page 		= require "./pageManage.js"; 		page.initial!
		map 		= require "./mapManage.js"; 		map.initial!
		main 	 	= require "./mainManage.js"; 		main.initial _data
		require_ 	= require "./requireManage.js"; 	require_.initial!


	_main-init = (result)->
		_init-all-module!


	_main-init!

