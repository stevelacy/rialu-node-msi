$(document).ready(function(){

var socket = io.connect('http://node.la:5000');
socket.on('connect', function(connect) {
  console.log(connect);
})
$('#panic').click(function(){
  socket.emit('panic', {panic:'panic'});
  console.log('panic')
})


$('#slider').slider({
	value: 50,
	slide: function(e, ui){
		$('#volume').text(ui.value)
	},
	change: function(e, ui){
		socket.emit('volume', {volume:ui.value})
	}
});

})