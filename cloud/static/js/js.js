$(document).ready(function(){

$('#location, #keyboard-box, body #toast').hide();

/*var check = localStorage.getItem("desktop");
if (check == 1) {
	window.location.replace("/desktop");
}*/

var socket = io.connect('//node.la:5000');
socket.on('connect', function(connect) {
  console.log(connect);
});

socket.on('users', function(users){
	console.log(users);
});

socket.on('clients', function(clients){
	console.log(clients.client[0]);
	for (var i = 0; i < clients.client.length; i++){
		$('#navDrawer').append('<a href="/'+clients.client[i]._id+'"><li class="bg-white-shade">'+clients.client[i].nickname+'</li></a>');
		$('#clientList').append('<a href="/'+clients.client[i]._id+'"><li class="bg-white">'+clients.client[i].nickname+' <div class="delete-item" id="delete-item" data-id="'+clients.client[i]._id+'">X</div></li></a>');
	}
	
});
socket.on('gps', function(gps){
	gps = gps.gps.gps;
	$('#location').fadeIn();
	$('#map').html('').append('<h3>Accuracy: '+gps.accuracy+'</h3><iframe width="100%" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/maps?q='+gps.latitude+'++'+gps.longitude+'&amp;output=embed"></iframe>');
});

socket.on('reply', function(reply){
	if (reply.message == "connected") return $('#toast').fadeIn(400).text(reply.device+" "+reply.message).delay(500).fadeOut();
	if (reply.message == "Panic Started!") return checkDesktop(reply.device, reply.message);
	$('#toast').fadeIn(400).text(reply.message).delay(500).fadeOut();
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
$('#keyboard').click(function(){
	$('#keyboard-box').fadeIn();
});
$('body #close').click(function(){
	$(this).parent().fadeOut();
});

$('#keyboard-set').click(function(keyboard){
	data = {
		left: {
			color: $('#color-left').val(),
			intensity: $('#intensity-left').val()
		},
		middle: {
			color: $('#color-center').val(),
			intensity: $('#intensity-center').val()
		},
		right: {
			color: $('#color-right').val(),
			intensity: $('#intensity-right').val()
		},
	}
	socket.emit('keyboard', {data:data, client:client});
	console.log(data);
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


if (window.navigator.userAgent == "rialu-app") {
	$(".desktop").hide();
}


// Navigation drawer
var slide = 0;
$('#slide-menu').click(function(){
	if (slide == 0) {
		$('.content').animate({
			left: ($('body').width() *0.5)
		});
		slide = 1;
	}
	else{
	$('.content').animate({
			left: '0'
		});
		slide = 0;
	}
});

 $('.content').draggable({
	axis: "x",
	start: function(event, ui) {
    start = ui.position.left;
    },
  stop: function(event, ui) {
    stop = ui.position.left;
    if(stop > start){
			$(this).animate({
				left: ($('body').width() *0.5)
			});
    }
		else{
			$(this).animate({
					left:'0'
				});
			}
	}
});


});