clientio  = require 'socket.io-client'

client = clientio.connect 'http://node.la:4000'



client.on 'connect', (socket) ->
	console.log "connected"
	client.on 'test', (test) ->
		console.log test
