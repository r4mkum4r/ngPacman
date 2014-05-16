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

				@socket = io.connect('http://10.203.100.132:3000', {
					reconnect : false
				})


		new gameCanvas
	])