angular.module 'pacman.services'
	.service 'BallModel', ->

		class BallModel

			defaults = {

				pos : {
					x : 100,
					y : 100
				},
				radius : 10,
				speed : {
					x : 3,
					y : 4
				}

			}

			constructor : (options) ->

				@options = angular.extend {}, defaults, options

			setX : (newX)=>

				@options.pos.x = newX

			getX : =>

				@options.pos.x

			setY : (newY)=>

				@options.pos.y = newY

			getY : =>

				@options.pos.y	
		
			update : =>

				if @options.pos.x + ( @options.radius * 2 ) > 1090 || @options.pos.x - @options.radius < 0
					@options.speed.x *= -1																																												

				if @options.pos.y + ( @options.radius * 2 ) > 400 || @options.pos.y - @options.radius < 0
					@options.speed.y *= -1

				@options.pos.x += @options.speed.x
				@options.pos.y += @options.speed.y

			draw : (canvas)=>

				grd = canvas.createRadialGradient(75,50,5,90,60,100)
				grd.addColorStop(0,"black")
				grd.addColorStop(.45,"red")
				grd.addColorStop(1,"black")

				canvas.beginPath()
				canvas.arc(@options.pos.x, @options.pos.y, @options.radius, 0, Math.PI * 2)
				canvas.closePath()
				canvas.fillStyle = grd
				canvas.fill()