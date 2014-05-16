angular.module('pacman.services')
	.service 'PlayerModel', ->

		class PlayerModel

			defaults = {
				id : 0
				pos : {
					x : 0,
					y : 0
				}
				speed : {
					x : 2,
					y : 4
				}
				type : 0
				isHost : false
				dimensions : {
					width: 20,
					height: 100
				}
			}

			constructor : (player) ->

				@options = angular.extend {}, defaults, player


			setX : (newX)=>

				this.options.pos.x = newX

			getX : =>

				this.options.pos.x

			setY : (newY)=>

				this.options.pos.y = newY

			getY : =>

				this.options.pos.y	

			getId : ->

				this.options.id

			getType : ->

				this.options.type

			update : (key) ->

				if @getY() + this.options.dimensions.height > 400
					@setY(400 - this.options.dimensions.height)

				if @getY() < 0
					@setY(0)

				if key is 38
					@setY(@getY() - this.options.speed.y)

				if key is 40
					@setY(@getY() + this.options.speed.y)			

			draw : (canvas)=>
				canvas.fillRect this.options.pos.x, this.options.pos.y, this.options.dimensions.width, this.options.dimensions.height						