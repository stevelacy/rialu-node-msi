express = require 'express'
http = require 'http'
io = require 'socket.io'
#clientio  = require 'socket.io-client'

app = express() 
server = http.createServer app
io = io.listen server
server.listen 4000
 
app.get '/', (req, res) ->
  res.sendfile __dirname + '/static/index.html'
 

#client = clientio.connect 'http://localhost:4000'
 
io.sockets.on 'connection', (socket) ->
	socket.emit 'test', {test: "test"}
	socket.on 'test', (test) ->
		console.log test
  socket.on 'client', (data) ->
    console.log 'clientserver data', data
    #client.emit 'my event', data
    
