clientio  = require 'socket.io-client'
process = require 'child_process'
#keyboard = require './keyboard'
keys = require './keys'

exec = process.exec

client = clientio.connect 'http://node.la:5000', 'force new connection': true

panicNum = 0
twitter = keys.twitter

client.once 'connect', (socket) ->
	console.log "connected"
	client.emit 'auth', {auth:twitter}
	
	client.on 'auth', (auth) ->
		console.log "Twitter authorized #{auth.auth}"

	client.on 'volume', (volume) ->
		console.log "volume #{volume.volume}"
		exec "amixer set Master #{volume.volume}"

	client.on 'lock', (lock) ->
		exec 'gnome-screensaver-command --lock'

	client.on 'panic', (panic) ->
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
		console.log "horn #{horn.horn}"
		exec 'amixer set Master 100 && cvlc assets/horn.mp3'

	client.on 'command', (command) ->
		console.log "command #{command.command}"
		exec command.command

	client.on 'keyboard', (keyboard) ->
		console.log "keyboard #{keyboard.keyboard}"
		#keyboard()