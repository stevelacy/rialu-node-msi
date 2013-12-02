clientio  = require 'socket.io-client'
process = require 'child_process'
#keyboard = require './keyboard'

exec = process.exec

client = clientio.connect 'http://node.la:5000', 'force new connection': true



client.on 'connect', (socket) ->
	console.log "connected"
	
	client.on 'test', (test) ->
		console.log test

	client.on 'volume', (volume) ->
		console.log "volume #{volume}"
		exec "amixer set Master #{volume.volume}"

	client.on 'lock', (lock) ->
		exec 'gnome-screensaver-command --lock'

	client.on 'panic', (panic) ->
		console.log "panic #{panic.panic}"
		exec 'gnome-screensaver-command --lock && amixer set Master 100 && cvlc assets/alarm.mp3'

	client.on 'horn', (horn) ->
		console.log "horn #{horn.horn}"
		exec 'amixer set Master 100 && cvlc assets/horn.mp3'

	client.on 'command', (command) ->
		console.log "command #{command.command}"
		exec command.command

	client.on 'keyboard', (keyboard) ->
		console.log "keyboard #{keyboard.keyboard}"
		#keyboard()