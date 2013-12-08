$(document).ready(function(){

var gui = require('nw.gui');
var sys = require('sys');
var exec = require('child_process').exec;
var win = gui.Window.get();

























$('#location').hide();
$('body #toast').hide();

var check = localStorage.getItem("desktop");
if (check != 1) {
	window.location.replace("/");
}



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
		//$('#navDrawer').append('<a href="client.html#'+clients.client[i]._id+'"><li class="bg-white-shade">'+clients.client[i].nickname+'</li></a>');
		$('#clientList').append('<a href="client.html#'+clients.client[i].nickname+'"><li class="bg-white">'+clients.client[i].nickname+' <div class="delete-item" id="delete-item" data-id="'+clients.client[i]._id+'">X</div></li></a>');
	}
	
});
socket.on('gps', function(gps){
	gps = gps.gps.gps;
	$('#location').fadeIn();
	$('#map').html('').append('<h3>Accuracy: '+gps.accuracy+'</h3><iframe width="100%" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/maps?q='+gps.latitude+'++'+gps.longitude+'&amp;output=embed"></iframe>');
});

socket.on('reply', function(reply){
	if (reply.message == "connected") return $('#toast').fadeIn(400).text(reply.device+" "+reply.message).delay(500).fadeOut();
	if (reply.message == "Panic Started!") return notification(reply.device, reply.message, "error");
	$('#toast').fadeIn(400).text(reply.message).delay(500).fadeOut();
});



var notification = function(device, message, icon){
	exec ("notify-send '"+message+"' '"+device+"' -i "+ icon);
};


});