mongoose = require 'mongoose'

models = require './models'
config = require './config'

db = mongoose.connect config.mongo.url


mongoose.connection.once 'connected', ->
	console.log "connected to mongo"


module.exports = models
module.exports = db