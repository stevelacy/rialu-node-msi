http = require 'http'
io = require 'socket.io'
express = require 'express'
passport = require 'passport'
passportSocketIO = require 'passport.socketio'
sessionStore = require './sessionstore'
server = require './httpserver'
config = require '../config'

io = io.listen server




onAuthorizeSuccess = (data, accept) ->
  console.log "successful connection to socket.io"
  accept null, true
onAuthorizeFail = (data, message, error, accept) ->
  throw new Error(message)  if error
  console.log "failed connection to socket.io:", message
  accept null, true

io.set "authorization", passportSocketIO.authorize
  cookieParser: express.cookieParser
  key: "express.sid"
  secret: config.cookieSecret
  store: sessionStore
  success: onAuthorizeSuccess
  fail: onAuthorizeFail




io.on 'connection', (socket) ->
  return console.log 'socket error - user not authorized' unless socket.handshake.user?
  user = socket.handshake.user

  socket.emit 'connect', {connect: "connect"}
  if user
    room = user.twitter
    socket.join room
    console.log room

  else
    room = ''
    socket.join room

  socket.on 'auth', (auth) ->
    console.log "auth #{auth.auth}"
    room = auth.auth
    socket.join room
    socket.emit 'auth', {auth:auth.auth}

  socket.on 'panic', (panic) ->
  	console.log "panic"
  	socket.broadcast.to(room).emit 'panic', {panic:panic}
  	
  socket.on 'volume', (volume) ->
  	console.log "volume #{volume.volume}"
  	socket.broadcast.to(room).emit 'volume', {volume:volume.volume}

  socket.on 'lock', (lock) ->
  	console.log "lock #{lock.lock}"
  	socket.broadcast.to(room).emit 'lock', {lock:lock}

  socket.on 'horn', (horn) ->
  	console.log "horn #{horn.horn}"
  	socket.broadcast.to(room).emit 'horn', {horn:horn}

  socket.on 'command', (command) ->
  	console.log "command #{command.command}"
  	socket.broadcast.to(room).emit 'command', {command:command.command}

  	
  socket.on 'keyboard', (keyboard) ->
  	console.log "#{keyboard.keyboard}"
  	socket.broadcast.to(room).emit 'keyboard', {keyboard:keyboard}