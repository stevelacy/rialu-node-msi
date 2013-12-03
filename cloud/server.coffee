http = require 'http'
express = require 'express'
mongoose = require 'mongoose'
io = require 'socket.io'


app = require './http/express'
webapp = require './http/webapp'
passport = require './http/passport'
sockets = require './http/sockets'
server = require './http/httpserver'
config = require './config'


console.log "listening on #{config.port}"

