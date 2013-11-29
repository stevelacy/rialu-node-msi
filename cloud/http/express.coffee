express = require 'express'
stylus = require 'stylus'

app = express() 

compile = (str, path) ->
	stylus(str).set('filename', path)

app.configure () ->
	app.set 'view engine', 'jade'
	app.set 'views', 'views'
	app.use stylus.middleware
		src: 'static'
		compile:compile
	app.use express.static 'static'
	app.use express.json()
	app.use express.urlencoded()
	app.use express.methodOverride()
	app.use express.cookieParser()




module.exports = app