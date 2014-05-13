angular.module('pacman.services')
	.factory 'PlayerModel', ->

		class PlayerModel

			id = 0
			pos = {
				x : 0,
				y : 0
			}
			speed = {
				x : 2,
				y : 4
			}
			type = 0
			dimensions = {
				width: 20,
				height: 100
			}

			constructor : (player, startX, startY) ->

				id = player.id
				type = player.type
				pos.x = startX
				pos.y = startY


			setX : (newX)=>

				pos.x = newX

			getX : =>

				pos.x

			setY : (newY)=>

				pos.y = newY

			getY : =>

				pos.y	

			getId : ->

				id

			update : (key) ->

				if @getY() + dimensions.height > 400
					@setY(400 - dimensions.height)

				if @getY() < 0
					@setY(0)

				if key is 38
					@setY(@getY() - speed.y)

				if key is 40
					@setY(@getY() + speed.y)			

			draw : (canvas)=>
				canvas.fillRect pos.x, pos.y, dimensions.width, dimensions.height						