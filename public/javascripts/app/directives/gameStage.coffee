angular.module 'pacman.directives'
	.directive 'gameStage', ['canvasService', (canvasService) ->

		{
			link : (scope, elem, attrs)->

				angular.element(window).bind 'keydown', (e)->
					switch e.keyCode
						when 38 then canvasService.updatePlayer(-1)
						when 40 then canvasService.updatePlayer(1)


		}



	]