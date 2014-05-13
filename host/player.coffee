class Player

	id = 0
	x = 0
	y = 0
	speed = {
		x : 2,
		y : 2
	}

	init : (startX, startY) ->

		console.log 'init'

module.exports = Player