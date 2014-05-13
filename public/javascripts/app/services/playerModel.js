// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

angular.module('pacman.services').factory('PlayerModel', function() {
  var PlayerModel;
  return PlayerModel = (function() {
    var dimensions, id, pos, speed, type;

    id = 0;

    pos = {
      x: 0,
      y: 0
    };

    speed = {
      x: 2,
      y: 4
    };

    type = 0;

    dimensions = {
      width: 20,
      height: 100
    };

    function PlayerModel(player, startX, startY) {
      this.draw = __bind(this.draw, this);
      this.getY = __bind(this.getY, this);
      this.setY = __bind(this.setY, this);
      this.getX = __bind(this.getX, this);
      this.setX = __bind(this.setX, this);
      id = player.id;
      type = player.type;
      pos.x = startX;
      pos.y = startY;
    }

    PlayerModel.prototype.setX = function(newX) {
      return pos.x = newX;
    };

    PlayerModel.prototype.getX = function() {
      return pos.x;
    };

    PlayerModel.prototype.setY = function(newY) {
      return pos.y = newY;
    };

    PlayerModel.prototype.getY = function() {
      return pos.y;
    };

    PlayerModel.prototype.getId = function() {
      return id;
    };

    PlayerModel.prototype.update = function(key) {
      if (this.getY() + dimensions.height > 400) {
        this.setY(400 - dimensions.height);
      }
      if (this.getY() < 0) {
        this.setY(0);
      }
      if (key === 38) {
        this.setY(this.getY() - speed.y);
      }
      if (key === 40) {
        return this.setY(this.getY() + speed.y);
      }
    };

    PlayerModel.prototype.draw = function(canvas) {
      return canvas.fillRect(pos.x, pos.y, dimensions.width, dimensions.height);
    };

    return PlayerModel;

  })();
});
