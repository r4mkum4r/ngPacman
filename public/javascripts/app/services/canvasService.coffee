angular.module('pacman.services')
	.service('canvasService', ['$q' , ($q)->

		class gameCanvas

			@scope = ''
			


			constructor : ->
				

			init : (scope)=>

				@scope = scope
				@player = {
					id : 0
				}
				defer = $q.defer()

				@socket = io.connect('http://localhost:3000', {
					reconnect : false
				})

			updatePlayer : (y)->

				@socket.emit 'clientMoved', y

				# canvas.clearRect 0,newY, 10,50

				# newY += y

				# canvas.fillRect 0,newY, 10,50


		new gameCanvas
	])