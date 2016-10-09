
map = null

main = null

page-manage = let
	
	_datas = null

	_type = 0

	_toggle-doms: [$("\#info"), $("\#map")]

	_init: !->
		@_dialog = $ "\#dialog"

	_init-depend-module: !->
		map 	:= require "./mapManage.js"
		main 	:= require "./mainManage.js"

	toggle: (page, options)!->
		for dom in @_toggle-doms
			dom.add-class "hide" 
		$ "\##{page}" .remove-class "hide"
		if page is "map"
			_datas := null
			map.reset!
			$("body").css({
				"background-color": "\#fff"
			})
		else if page is "info"
			_datas := options
			main.set-temps options
			@_dialog.find ".location-dialog input\#location-select" .val options.address
			$("body").css({
				"background-color": "\#FFFBF0"
			})

	dialog: (page, options)!->

		@_dialog.find ".dialog" .add-class "hide"
		if page is "exist"
			@_dialog.add-class "hide"
		else
			@_dialog.remove-class "hide"
			$dialog = @_dialog.find ".#{page}-dialog" .remove-class "hide"
			if page is "location"
				if options
					_type := 0
					$dialog.find ".title-field p" .html "修改配送地址"
					$dialog.find "input\#location-select" .val (options.address || "")
					$dialog.find "input\#extra-location" .val (options.detail || "")
				else
					_type := 1
					$dialog.find ".title-field p" .html "新建配送地址"
					$dialog.find "input\#location-select" .val ""
					$dialog.find "input\#extra-location" .val ""

	initial: !->
		@_init!
		@_init-depend-module!

module.exports = page-manage