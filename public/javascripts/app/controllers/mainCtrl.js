// Generated by CoffeeScript 1.7.1
angular.module('pacman.controllers').controller('mainCtrl', [
  '$scope', 'canvasService', function($scope, canvasService) {
    $scope.stage = document.getElementById('stage');
    canvasService.scope = $scope;
    return canvasService.init();
  }
]);