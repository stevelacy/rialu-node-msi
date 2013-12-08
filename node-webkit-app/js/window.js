var gui = require('nw.gui');
var win = gui.Window.get();



var tray = new gui.Tray({title: "App",
	icon: "images/app.png",
	tooltip: "App!"
});

tray.on('click', function(){
	win.show();
});

var menu = new gui.Menu();
menu.append(new gui.MenuItem({
	type: 'checkbox',
	label: 'box',
	click: function(){
		if(this.checked !== true){return true;}
		alert("checked");
	}
}));
menu.append(new gui.MenuItem({ label: 'Item B' }));
menu.append(new gui.MenuItem({ type: 'separator' }));
item = new gui.MenuItem({
  label: "Click me",
  icon: "images/icon.png"
});
var submenu = new gui.Menu();
submenu.append(new gui.MenuItem({ label: 'Item 1' }));
submenu.append(new gui.MenuItem({ label: 'Item 2' }));
submenu.append(new gui.MenuItem({ label: 'Item 3' }));
item.submenu = submenu;
menu.append(item);
menu.append(new gui.MenuItem({
	label: 'Exit',
	click: function() {
		win.close();
  }

}));
tray.menu = menu;

// Window.on events
win.on('close', function() {
  this.hide();
});
win.on('minimize', function() {
  //this.hide();
});


