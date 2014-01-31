keyboard = require 'msi-keyboard'

module.exports = ->
  keyboard.color('left', {
      color: 'red',
      intensity: 'med'
  });

  keyboard.color('middle', 'green');

  keyboard.color('right', {
      color: 'sky',
      intensity: 'high',
  });


  keyboard.blink(['left'], 500);
  keyboard.blink(['middle'], 200);
  keyboard.blink(['right'], 500);
  