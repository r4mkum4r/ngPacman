// Generated by CoffeeScript 1.7.1
angular.module('pacman.directives').directive('gameStage', [
  'canvasService', function(canvasService) {
    return {
      link: function(scope, elem, attrs) {
        return angular.element(window).bind('keydown', function(e) {
          switch (e.keyCode) {
            case 38:
              return canvasService.updatePlayer(-1);
            case 40:
              return canvasService.updatePlayer(1);
          }
        });
      }
    };
  }
]);
