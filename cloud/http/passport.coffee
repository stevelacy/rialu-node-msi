passport = require 'passport'
passportTwitter = require 'passport-twitter'
passportSocketIO = require 'passport.socketio'

db = require '../db'
config = require '../config'

User = db.models.User


TwitterStrategey = passportTwitter.Strategy

passport.use new TwitterStrategey
	consumerKey: config.twitterKey
	consumerSecret: config.twitterSecret
	callbackURL: config.twitterCallback,
	(token, tokenSecret, profile, cb) ->
		User.findOne {twitter: profile.id}, (err, user) ->
			return console.log err if err?
			#icon = profile._json.profile_image_url_https.replace('_normal', '')
			icon = profile._json.profile_image_url_https
			userData = 
				username: profile._json.screen_name
				icon: icon
				twitter: String profile._json.id
			if user?
				console.log 1
				user.set userData
				user.save cb
				return cb null, user
			else
				console.log 2
				User.create userData, (err, user) ->
					console.log 3
					return console.log  err if err?
					cb null, user


passport.serializeUser (user, cb) ->
	cb null, user.twitter


passport.deserializeUser (id, cb) ->
	User.findOne ({twitter: id}), cb


module.exports = passport
