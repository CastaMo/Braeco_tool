require_ = page = null

[			addListener] = 
	[		util.addListener]

let $ = jQuery
	$.getUrlParam = (name)->
		reg = new RegExp("(^|&)#{name}=([^&]*)(&|$)")
		r = window.location.search.substr(1).match(reg)
		if r then return unescape(r[2])
		return null

main-manage = let

	_data = null

	_type = 0

	_index = 0

	_temps = null

	_order-price = 0

	_success-callback = {
		"0": (item, index)!->
			_data.location.eater[index] = item
			main-manage._render-dom _data

		"1": (item)!->
			_data.location.eater.unshift item
			main-manage._render-dom _data
	}

	_get-able-info-for-location = (able)->
		if able is -2 then return ""
		else if able is -1 then return " (地址过远无法配送)"
		else if able >= 0 then return " (起送价为#{_data.ladder[able][1]}元, 当前订单价格为#{_order-price}元)"

	tmpl-manage = let
		location-container: (data)->
			return "
						#{(for loc, i in data.location.eater
							"<li class='location-item#{if loc.able >= -1 then " disabled" else ""}' data-index=#{i}>
		                        <div class='location-main'>
		                            <div class='left-part location-content'>
		                                <div class='top-field parallel-container'>
		                                    <div class='choose-icon'></div>
		                                    <div class='location-basic-field'>
		                                    	<span class='choose hide'>当前地址</span>
		                                    	<span>#{loc.address}</span>
		                                    </div>
		                                    <div class='clear'></div>
		                                </div>
		                                <div class='bottom-field'>
		                                    <div class='location-extra-field'>
		                                        <p>#{loc.detail}#{_get-able-info-for-location(loc.able)}</p>
		                                    </div>
		                                </div>
		                            </div>
		                            <div class='right-part location-icon vertical-center'>
		                                <div class='edit-field'>
		                                    <div class='edit-icon'></div>
		                                </div>
		                            </div>
		                            <div class='clear'></div>
		                        </div>
		                        <div class='fivePercentLeftLine'></div>
		                    </li>"
						).join("")}
	                "

	_getDistanceBetween = (point1, point2)->
		lat1 = point1.lat * Math.PI / 180
		lng1 = point1.long * Math.PI / 180
		lat2 = point2.lat * Math.PI / 180
		lng2 = point2.long * Math.PI / 180

		calcLongitude = lng2 - lng1
		calcLatitude = lat2 - lat1
		stepOne = Math.pow(Math.sin(calcLatitude / 2), 2) + Math.cos(lat1) * Math.cos(lat2) * Math.pow(Math.sin(calcLongitude / 2), 2)
		stepTwo = 2 * Math.asin(Math.min(1, Math.sqrt(stepOne)))
		result = 6371393 * stepTwo
		return Math.round(result)

	_select: (index)!->
		$ "\#location ul.location-list li" .remove-class "choose" .find "span.choose" .add-class "hide"
		$ "\#location ul.location-list li[data-index=#{index}]" .add-class "choose" .find "span.choose" .remove-class "hide"

	_render-dom: (data)!->
		dinner = data.location.dinner
		last-distance = data.ladder[data.ladder.length - 1][0]
		for item in data.location.eater
			dis = _getDistanceBetween(dinner, item)
			if dis > last-distance
				item.able = -1
				continue
			index = data.ladder.length - 1
			max = data.ladder[0]
			for ladder-item, i in data.ladder
				if i is 0 then min = ladder-item
				else min = data.ladder[i - 1]
				max = ladder-item
				if min[0] <= dis and dis <= max[0]
					if max[1] <= _order-price
						item.able = -2
					else
						item.able = i
					break

		str = tmpl-manage.location-container data
		$ "\#location ul.location-list" .html str
		for item, i in data.location.eater when item.able is -2
			return @_select i

	_init-depend-module: !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"

	_bindEvt: !->
		$(".location-add-btn").on "click", !->
			page.dialog "location"
			_type := 1
			_temps := null

		$(".location-dialog").on "click", "input\#location-select", (e)!->
			e.prevent-default!
			page.toggle "map"

		$("\#dialog").on "click", ".close-field", !->
			page.dialog "exist"

		$("\#dialog").on "click", ".confirm-btn", !->
			if not _temps then return alert "请选择地址"
			detail = $("\#dialog input\#extra-location").val!
			if not detail then return alert "请输入详细地址"
			page.dialog "exist"
			_temps.detail = detail
			if _type is 0
				require_.get("update").require {
					data: {
						JSON 	: JSON.stringify(_temps)
						id 		: _temps.id
					}
					success: (result)!->
						_success-callback[0] _temps, _index
				}
			else if _type is 1
				require_.get("add").require {
					data: {
						JSON 	: JSON.stringify(_temps)
					}
					success: (result)!->
						_temps.id = result.id
						_success-callback[1] _temps
				}

		$(".location-container").on "click", "li.location-item .location-icon", (e)!->
			index = $(@).parents("li").data("index")
			_index := index
			item = _data.location.eater[index]
			_type := 0
			_temps := item
			page.dialog "location", {
				address: item.address
				detail: item.detail
			}
			return false

		$(".location-container").on "click", "li.location-item", (e)!->
			if $(@).has-class "disabled" then return
			index = $(@).data("index")
			require_.get("choose").require {
				data: {
					id: _data.location.eater[index].id
				}
				success: !~>
					main-manage._select index
			}

	set-temps: (temps)!->
		if _temps then _temps <<< temps
		else _temps := temps

	initial: (data)!->
		_data := data
		_order-price := Number($.getUrlParam("orderPrice"))
		console.log _data
		dinner = data.location.dinner
		last-distance = data.ladder[data.ladder.length - 1][0]
		data.location.eater.sort (a, b)->
			return _getDistanceBetween(dinner, a) > _getDistanceBetween(dinner, b)
		@_render-dom data
		@_init-depend-module!
		@_bindEvt!

module.exports = main-manage