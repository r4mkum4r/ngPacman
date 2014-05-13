angular.module('pacman.directives')
	.directive 'gameStage', ['canvasService','$compile','PlayerModel','$timeout', (canvasService, $compile, PlayerModel, $timeout) ->

		{
			controller : [
				'$scope', '$timeout', '$interval',
				($scope, $timeout, $interval)->
					class gameStage

						init : (stageWidth, stageHeight)=>

							@gameConfig = {
								speedX : 2,
								speedY : 2
							}
							@stage = {}
							@ball = {
								radius : 10,
								posX : 500,
								posY : 100,
								speedX : 2,
								speedY : 2
							}
							@userControl = {
								isDown : false,
								isTop : false
							}

							@stage.height = stageHeight
							@stage.width = stageWidth

							$scope.$canvas = $($scope.canvas)
							$scope.isLocalPlayerJoined = false
							$scope.localPlayer = false
							$scope.players = []
							''

						
						startGame : =>

							@update()
							

						clearStage : =>
							$scope.canvas.clearRect 0,0,@stage.width,@stage.height

						drawGameElements : =>

							@drawPlayers()

							if (@player.posX < @ball.posX + @ball.radius  and @player.posX + @player.width  > @ball.posX and @player.posY < @ball.posY + @ball.radius and @player.posY + @player.height > @ball.posY) 
								
								@ball.speedX *= -1

								$timeout(=>
									@ball.speedX += 3
									@player.speedX += 1
								, 50)

						createPlayer : (player, startX, startY)=>
							
							newPlayer = new PlayerModel(player, startX, startY)

							# @clearStage()

							newPlayer.draw($scope.canvas)
							if $scope.localPlayer
								$scope.localPlayer.draw($scope.canvas)
							
							if $scope.isLocalPlayerJoined is true
								$scope.players.push newPlayer
								
							else
								$scope.localPlayer = newPlayer
								$scope.isLocalPlayerJoined = true

							@setupControls()

							# @update()

						update : =>

							@updatePlayers()

							@updateBall()

							window.requestAnimFrame(@update)

						updatePlayers : =>

							@clearStage()

							$scope.localPlayer.draw $scope.canvas

							# if $scope.players.length > 0
							# 	console.log 'remote'
								# $scope.players[0].draw $scope.canvas							

							$scope.players.forEach((player)->
								player.draw $scope.canvas
							)

						updateBall : ->

							if @ball.posX + ( @ball.radius * 2 ) > @stage.width || @ball.posX - @ball.radius < 0
								@ball.speedX *= -1							

							# if  @ball.posX < 0
							# 	$interval.cancel(@interval)

							if @ball.posY + ( @ball.radius * 2 ) > @stage.height || @ball.posY - @ball.radius < 0
								@ball.speedY *= -1
							
							@ball.posX += @ball.speedX
							@ball.posY += @ball.speedY

						drawBall : =>

							$scope.canvas.beginPath();
							$scope.canvas.arc(@ball.posX, @ball.posY, @ball.radius, 0, Math.PI*2, true);
							$scope.canvas.closePath();
							$scope.canvas.fill();

						setupControls : =>

							$(document).on 'keydown', (e)=>
								if e.keyCode is 38 or e.keyCode is 40
									$scope.localPlayer.update e.keyCode
														

					new gameStage
			]
			link : (scope, elem, attrs, ctrl)->

				scope.stage = elem[0]
				scope.canvas = scope.stage.getContext('2d')

				ctrl.init($(elem).width(), $(elem).height())

				canvasService.socket.on 'createPlayer', (player)->
					if player.type is 1
						ctrl.createPlayer player, 0, 0
					else if player.type is 2
						ctrl.createPlayer player, 1090, 0	

				canvasService.socket.on 'startGame', (players)->
					

				
		}



	]