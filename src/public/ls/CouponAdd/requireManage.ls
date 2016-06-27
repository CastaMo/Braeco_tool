require-manage = let

	[		get-JSON,		ajax,		deep-copy] 		= 
		[	util.get-JSON, 	util.ajax,	util.deep-copy]

	###
	#	请求名字(自己设)
	###
	_all-require-name = [
		'couponAdd'
	]

	###
	#	请求名字与URL键值对(与后台进行商量)，名字需依赖于上述对象
	###
	_all-require-URL = {
		'couponAdd' 		:		'/coupon/add'
	}

	_requires = {}


	###
	#	ajax请求基本配置，无特殊情况不要改
	###
	_default-config = {
		async 	:	true
		type 	:	"POST"
	}

	###
	#	获取一个基本的ajax请求对象，主要有url、type、async的配置
	###
	_get-normal-ajax-object = (config)->
		return {
			url 		:		config.url
			type 		:		config.type
			async 	:		config.async
		}




	###
	#	ajax请求对象对应的数据请求属性，以键值对Object呈现于此
	###
	_get-require-data-str = {
		"couponAdd" 		:		(data)-> return "#{data.JSON}"
	}

	_correct-URL = {
		"weixinPay"			:		(ajax-object, data)-> ajax-object.url += "/#{data.url}"
	}

	_set-header = {
	}


	###
	#	在状态码为200，即请求成功返回时的处理
	#	@{param}	name: 		请求对象的名字
	#	@{param}	result_:	返回值，即ResponseText
	#	@{param}	callback:	当返回的message为success时执行的回调函数
	###
	_normal-handle = (name, result_, callback)->
		result = get-JSON result_
		message = result.message
		if message is "success" then callback?(result)
		else if message then _require-fail-callback[name][message]?!
		else alert "系统错误"


	###
	#	在请求状态码为200且返回的message属性不为success时的处理方法
	###
	_require-fail-callback = {
		"couponAdd"		:		{
			"Invalid QR" 					:	-> alert "二维码有误"
		}
	}


	###
	#	用于获取每个请求对象的require函数方法
	#	@param	{String}	name:		请求对象的名字
	#	@param	{Object}	config:		请求的基本配置
	#	@return	{Fn}					执行ajax请求，需要依赖于上面的函数方法
	###
	_require-handle = (name, config)->
		return (options)->
			try
				ajax-object = _get-normal-ajax-object config
				ajax-object.data = _get-require-data-str[name]? options.data
				_correct-URL&&_correct-URL[name]? ajax-object, options.data
				_set-header&&_set-header[name]? ajax-object, options.data
				ajax-object.success = (result_)-> _normal-handle name, result_, options.success
				ajax-object.always = options.always
				ajax ajax-object
			catch error
				alert error
			


	class Require

		(options)->
			deep-copy options, @
			@init()
			_requires[@name] = @

		init: ->
			@init-require!

		init-require: ->
			config = {}
			deep-copy _default-config, config
			config.url = @url
			@require = _require-handle @name, config

	_init-all-require = ->
		for name, i in _all-require-name
			require = new Require {
				name 		:		name
				url 		:		_all-require-URL[name]
			}


	get: (name)-> return _requires[name]

	initial: ->
		_init-all-require!
module.exports = require-manage
