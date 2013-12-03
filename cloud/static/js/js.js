$(document).ready(function(){

var socket = io.connect('http://node.la:5000');
socket.on('connect', function(connect) {
  console.log(connect);
});
$('#panic').click(function(){
  socket.emit('panic', {panic:'panic'});
});
$('#lock').click(function(){
	socket.emit('lock', {lock:'lock'});
});
$('#horn').click(function(){
	socket.emit('horn', {horn:'horn'});
});

var sendCommand = function(command){
	socket.emit('command', {command:command});
};


$('#slider').slider({
	value: 50,
	slide: function(e, ui){
		$('#volume').text(ui.value);
	},
	change: function(e, ui){
		socket.emit('volume', {volume:ui.value});
	}
});

$('#command-form').submit(function(){
	sendCommand($('#command').val());
	$('#command').val('');
	return false;
});


// Navigation drawer
 $('.content').draggable({
	axis: "x",
	start: function(event, ui) {
    start = ui.position.left;
    },
  stop: function(event, ui) {
    stop = ui.position.left;
    if(stop > start){
			$(this).animate({
				left: ($('body').width() *.5)
			})
    }
		else{
			$(this).animate({
					left:'0'
				})
			}
	}
});


});