express = require 'express'
stylus = require 'stylus'
config = require '../config'
sessionStore = require './sessionstore'
passport = require './passport'

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
	app.use	express.session({
		store: sessionStore
		key: 'express.sid'
		secret: config.cookieSecret
		maxAge: new Date(Date.now() + 36000000)
		expires: new Date(Date.now() + 36000000)
		})
	app.use passport.initialize()
	app.use passport.session()




module.exports = app