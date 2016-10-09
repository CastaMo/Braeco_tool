page = null

map-manage = let

	tmpl-manage = let
	
		address-container: (data)->

			str = "<ul class=\"address-list\">
						#{(for item, i in data.wr
							"<li class=\"adddress\" data-index='#{i}'>
								<div class=\"address-content\">
									<div class=\"left-part icon-field\">
										<div class=\"choose-icon\"></div>
									</div>
									<div class=\"right-part address-info-field\">
										<div class=\"title-desc parallel-container\">
											<div class=\"title\">#{item.title}</div>
											<div class=\"clear\"></div>
										</div>
										<p class=\"address-desc\">#{item.address}</p>
									</div>
									<div class=\"clear\"></div>
								</div>
								<div class=\"line88\"></div>
							</li>"
						).join ""}
					</ul>"
			return str

	_local = null

	_datas = null

	_myGeo = null

	_geolocation = null

	_map = null

	map: null

	select: (index)!->
		$ad = $("\#address-container")
		$ad.find("li").remove-class("choose")
						.find(".choose").remove!
		$ad.find("li[data-index=#{index}]").add-class("choose")
						.find(".title-desc")
						.prepend($("<div class='choose'>当前地址</div>"))

	_init: !->
		map = new BMap.Map('baidu-map')

		_map := map

		map.addControl(new BMap.NavigationControl())
		map.addControl(new BMap.GeolocationControl())

		localInitOptions = {
			onSearchComplete: (result)!->
				if local.getStatus! is BMAP_STATUS_SUCCESS
					_datas := result
					str = tmpl-manage.address-container result
					$ "\#address-container" .html str

			renderOptions: {
				map: map
			}	
		}
		_local := local = new BMap.LocalSearch(map, localInitOptions)

		local.setInfoHtmlSetCallback (item, info-dom)!->
			for data, i in _datas.wr when data.title is item.title and data.address is item.address
				return map-manage.select i

		myGeo = new BMap.Geocoder()

		_myGeo := myGeo

		geolocation = new BMap.Geolocation

		_geolocation := geolocation

	_bindEvt: !->
		$("input\#search").on("keyup", _.debounce(!->
			value = $("input\#search").val!
			if value
				_local.search value
		, 500))

		$(".reset-icon").on "click", !->
			$("input\#search").val ""

		$("\#address-container").on "click", "li", !->
			index = $(@).data "index"
			_local.select index
			item = _datas.wr[index]
			set-timeout !->
				page.toggle "info", {
					address: "#{item.address} #{item.title}"
					lat: item.point.lat
					long: item.point.lng
				}
			, 500

	_init-depend-module: !->
		page := require "./pageManage.js"

	initial: !->
		@_init!
		@_bindEvt!
		@_init-depend-module!

	reset: !->
		$("input\#search").val ""
		_geolocation.getCurrentPosition (result)!->
			if @getStatus! is BMAP_STATUS_SUCCESS
				point = result.point
				_map.centerAndZoom point, 15
				_myGeo.getLocation point, (result)->
					_local.search result.address


module.exports = map-manage