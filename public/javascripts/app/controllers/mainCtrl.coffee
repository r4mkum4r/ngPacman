angular.module('pacman.controllers')
	.controller 'mainCtrl', ['$scope','canvasService', ($scope, canvasService)->

		# $scope.title = 'ngPacman'
		# $scope.subtitle = 'Multiplayer Pacman'

		canvasService.init($scope)
	]