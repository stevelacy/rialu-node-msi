app = require './express'
passport = require './passport'


app.get '/', (req, res) ->
	return res.redirect 'login' unless req.user?
	res.render 'index'
app.get '/login', (req, res) ->
	res.render 'login'







## Passport urls
app.get '/auth/twitter', passport.authenticate('twitter')
app.get '/auth/twitter/callback',
	passport.authenticate 'twitter', {successRedirect:'/', falureRedirect:'/login'}
app.get '/logout', (req, res) ->
	req.logout()
	res.redirect '/'
##