angular.module 'pacman.controllers'
	.controller 'mainCtrl', ['$scope', 'canvasService', ($scope, canvasService)->

		# $scope.title = 'ngPacman'
		# $scope.subtitle = 'Multiplayer Pacman'
		
		$scope.stage = document.getElementById 'stage'

		canvasService.scope = $scope

		canvasService.init()
	]