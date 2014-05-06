class gameCanvas

	@scope = ''
	canvas = ''
	newY = 0
	player = {}

	constructor : ->
		

	init : ->

		@socket = io.connect()

		@socket.on 'createPlayer', (playerId)->
			player.id = playerId


		@socket.on 'moveClient', (posY, id)->

			if player.id is id

				canvas.clearRect 0,newY, 10,50

				newY += posY

				canvas.fillRect 0,newY, 10,50

			else

				canvas.clearRect 200,newY, 10,50

				newY += posY

				canvas.fillRect 200,newY, 10,50

		
		canvas = @scope.stage.getContext '2d'

		canvas.fillRect 0,0, 10,50
		canvas.fillRect 200,0, 10,50


	updatePlayer : (y)->

		@socket.emit 'clientMoved', y

		canvas.clearRect 0,newY, 10,50

		newY += y

		canvas.fillRect 0,newY, 10,50
		
		



angular.module('pacman.services')
	.service('canvasService', gameCanvas)