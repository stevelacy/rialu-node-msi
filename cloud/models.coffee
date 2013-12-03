mongoose = require 'mongoose'


userSchema = new mongoose.Schema
	username:
		type: String
		required: true
	twitter:
		type: String
		required: true


userSchema.set 'autoindex', false

exports.User = mongoose.model 'User', userSchema