$(document).ready(function(){


if(location.hash){
var client = location.hash;
var client = client.replace("#", "");
var socket = io.connect('//node.la:5000');

socket.on('connect', function(connect) {
  console.log(connect);
});


$('#panic').click(function(){
  socket.emit('panic', {panic:'panic', client:client});
});
$('#lock').click(function(){
	socket.emit('lock', {lock:'lock', client:client});
});
$('#horn').click(function(){
	socket.emit('horn', {horn:'horn', client:client});
});
$('#gps').click(function(){
	socket.emit('gps', {gps:'gps', client:client});
});

$('#close').click(function(){
	$(this).parent().fadeOut();
});
$(document).on('click', '#delete-item', function(e) {
	e.preventDefault();
	socket.emit('delete',{delete:$(this).attr('data-id')});
	$(this).parent().remove();
});

var sendCommand = function(command){
	socket.emit('command', {command:command, client:client});
};


$('#slider').slider({
	value: 50,
	slide: function(e, ui){
		$('#volume').text(ui.value);
	},
	change: function(e, ui){
		socket.emit('volume', {volume:ui.value, client:client});
	}
});

$('#command-form').submit(function(){
	sendCommand($('#command').val());
	$('#command').val('');
	return false;
});




} // end if hash
});