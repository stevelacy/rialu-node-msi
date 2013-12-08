$(document).ready(function(){
var gui = require('nw.gui');




$("#loginWindow").click(function(){
	var newWindow = gui.Window.open(
		'http://node.la/desktop/login',{
			position: "center",
			width: 500,
			height: 400
		}
	);

	newWindow.on('close', function(){
		window.location.replace("index.html");
		newWindow.close();
	});

});



});