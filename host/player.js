// Generated by CoffeeScript 1.7.1
var Player;

Player = (function() {
  var id, speed, x, y;

  function Player() {}

  id = 0;

  x = 0;

  y = 0;

  speed = {
    x: 2,
    y: 2
  };

  Player.prototype.init = function(startX, startY) {
    return console.log('init');
  };

  return Player;

})();

module.exports = Player;
