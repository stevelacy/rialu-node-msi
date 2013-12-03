http = require 'http'
io = require 'socket.io'
express = require 'express'
passport = require 'passport'
mongoose = require 'mongoose'
passportSocketIO = require 'passport.socketio'
sessionStore = require './sessionstore'
server = require './httpserver'
config = require '../config'
db = require '../db'

io = io.listen server

Client = db.models.Client



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
    Client.find {user:room}, (err, client) ->
      return console.log err if err? 
      if client?
        socket.emit 'clients', {client}
    

  else
    room = ''
    socket.join room

  socket.on 'auth', (auth) ->
    console.log "auth #{auth.auth}"
    room = auth.auth
    socket.join room
    socket.emit 'auth', {auth:auth.auth}
    Client.findOne {nickname:auth.nickname}, (err, client) ->
      return console.log err if err?
      clientData = 
        nickname: auth.nickname
        online: true
        user: room
      if client?
        client.set clientData
        client.save
        console.log "client saved #{client.nickname}"
      else
        Client.create clientData, (err, client) ->
          return err if err?
          console.log "client created #{client.nickname}"


  socket.on 'panic', (panic) ->
  	console.log "panic"
  	socket.broadcast.to(room).emit 'panic', {panic:panic, client:panic.client}
  	
  socket.on 'volume', (volume) ->
  	console.log "volume #{volume.volume}"
  	socket.broadcast.to(room).emit 'volume', {volume:volume.volume, client:volume.client}

  socket.on 'lock', (lock) ->
  	console.log "lock #{lock.lock}"
  	socket.broadcast.to(room).emit 'lock', {lock:lock, client:lock.client}

  socket.on 'horn', (horn) ->
  	console.log "horn #{horn.horn}"
  	socket.broadcast.to(room).emit 'horn', {horn:horn, client:horn.client}

  socket.on 'command', (command) ->
  	console.log "command #{command.command}"
  	socket.broadcast.to(room).emit 'command', {command:command.command, client:command.client}

  	
  socket.on 'keyboard', (keyboard) ->
  	console.log "#{keyboard.keyboard}"
  	socket.broadcast.to(room).emit 'keyboard', {keyboard:keyboard, client:keyboard.client}


  socket.on 'delete', (del) ->
    console.log "deleting #{del.delete}"
    id = mongoose.Types.ObjectId del.delete
    Client.findByIdAndRemove id, (err, del) ->
      return console.log err if err?
      console.log "deleted #{del}"
