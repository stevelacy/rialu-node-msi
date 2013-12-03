clientio  = require 'socket.io-client'
process = require 'child_process'
#keyboard = require './keyboard'
keys = require './keys'
config = require './config'

exec = process.exec

client = clientio.connect 'http://node.la:5000', 'force new connection': true

panicNum = 0
twitter = keys.twitter

client.once 'connect', (socket) ->
	console.log "connected"
	client.emit 'auth', {auth:twitter, nickname:config.nickname}
	
	client.on 'auth', (auth) ->
		console.log "Twitter authorized #{auth.auth}"

	client.on 'volume', (volume) ->
		return true unless volume.client == config.nickname
		console.log "volume #{volume.volume}"
		exec "amixer set Master #{volume.volume}"

	client.on 'lock', (lock) ->
		return true unless lock.client == config.nickname
		exec 'gnome-screensaver-command --lock'

	client.on 'panic', (panic) ->
		return true unless panic.client == config.nickname
		console.log "panic #{panic.panic}"
		if panicNum == 0
			panicNum = 1
			exec 'gnome-screensaver-command --lock && amixer set Master 100 && cvlc assets/alarm.mp3'
			console.log 'panic 1'
		else
			panicNum = 0
			exec 'killall vlc'
			console.log 'panic 0'

	client.on 'horn', (horn) ->
		return true unless horn.client == config.nickname
		console.log "horn #{horn.horn}"
		exec 'amixer set Master 100 && cvlc assets/horn.mp3'

	client.on 'command', (command) ->
		return true unless command.client == config.nickname
		console.log "command #{command.command}"
		exec command.command

	client.on 'keyboard', (keyboard) ->
		return true unless keyboard.client == config.nickname
		console.log "keyboard #{keyboard.keyboard}"
		#keyboard()