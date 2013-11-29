http = require 'http'
io = require 'socket.io'

app = require './http/express'
require './http/webapp'


server = http.createServer app
server.listen 5000
io = io.listen server

room = 'private'

 

 
io.sockets.on 'connection', (socket) ->
	socket.emit 'connect', {connect: "connect"}

	socket.join room

	socket.on	'panic', (panic) ->
  	console.log "panic"
  	socket.broadcast.to(room).emit 'panic', {panic:panic}
  	
  socket.on 'volume', (volume) ->
  	console.log "volume #{volume.volume}"
  	socket.broadcast.to(room).emit 'volume', {volume:volume.volume}
  
  socket.on 'lock', (lock) ->
  	console.log "lock #{lock.lock}"
  	socket.broadcast.to(room).emit 'lock', {lock:lock}
  	
  socket.on 'keyboard', (keyboard) ->
  	console.log "#{keyboard.keyboard}"
  	socket.broadcast.to(room).emit 'keyboard', {keyboard:keyboard}