mongoose = require 'mongoose'
app = require './express'
passport = require './passport'
db = require '../db'

Client = db.models.Client




## Passport urls
app.get '/auth/twitter', passport.authenticate('twitter')
app.get '/auth/twitter/callback',
	passport.authenticate 'twitter', {successRedirect:'/', falureRedirect:'/login'}
app.get '/logout', (req, res) ->
	req.logout()
	res.redirect '/'
##


app.get '/', (req, res) ->
	return res.redirect 'login' unless req.user?
	res.render 'index', {test:'data'}
app.get '/login', (req, res) ->
	res.render 'login'
app.get '/:client', (req, res) ->
	id = mongoose.Types.ObjectId req.params.client
	Client.findOne {_id:id}, (err, client) ->
		return console.log err if err?
		return res.render 'error/404' unless client?
		res.render 'client', {user:req.user, pc:client.nickname}






