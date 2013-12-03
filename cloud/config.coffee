keys = require './keys'

config = 
	domain: 'node.la'
	port: 5000
	cookieSecret: 'kajfklajsfkljasklfjaskdfjaskfja;skfj'
	twitterKey: keys.twitterKey
	twitterSecret: keys.twitterSecret
	twitterCallback: "http://node.la/auth/twitter/callback"
	mongo:
		url: 'mongodb://127.0.0.1:27017/rialu'

module.exports = config