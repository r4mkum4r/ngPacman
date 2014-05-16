angular.module('pacman.directives')
	.directive 'gameStage', ['canvasService','$compile','$timeout','PlayerModel', 'BallModel', (canvasService, $compile, $timeout, PlayerModel, BallModel) ->

		{
			controller : [
				'$scope', '$timeout', '$interval','canvasService', 'BallModel',
				($scope, $timeout, $interval, canvasService, BallModel)->
					class gameStage

						init : (stageWidth, stageHeight)=>

							@gameConfig = {
								speedX : 2,
								speedY : 2
							}
							@stage = {}
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
							$scope.gameStarted = false
							''

						
						startGame : =>

							$scope.gameStarted = true
							@createBall()
							

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

						createPlayer : (player)=>

							if not $scope.localPlayer
								$scope.localPlayer = new PlayerModel player
								$scope.localPlayer.draw $scope.canvas
							else
								newPlayer = new PlayerModel player
								newPlayer.draw $scope.canvas
								$scope.players.push newPlayer

							@setupControls()

							@update()

						update : =>

							@clearStage()

							@updatePlayers()

							if $scope.ball
								@updateBall()

							window.requestAnimFrame(@update)

						updatePlayer : (player) =>
							if not ( $scope.localPlayer.getId() is player.options.id )
								$scope.players[0].setX player.options.pos.x
								$scope.players[0].setY player.options.pos.y

						updatePlayers : =>

							@clearStage()

							if $scope.localPlayer
								$scope.localPlayer.draw $scope.canvas

							if $scope.players.length > 0
								$scope.players[0].draw $scope.canvas	

							# @updateBall()					


						updateBall : =>

							if $scope.localPlayer.options.isHost and $scope.gameStarted
								$scope.ball.update()
								canvasService.socket.emit 'ballMoved', $scope.ball
								$scope.ball.draw($scope.canvas)
							else if $scope.ball
								$scope.ball.draw($scope.canvas)

							if ($scope.localPlayer.options.pos.x < $scope.ball.options.pos.x + $scope.ball.options.radius  and $scope.localPlayer.options.pos.x + $scope.localPlayer.options.dimensions.width  > $scope.ball.options.pos.x and $scope.localPlayer.options.pos.y < $scope.ball.options.pos.y + $scope.ball.options.radius and $scope.localPlayer.options.pos.y + $scope.localPlayer.options.dimensions.height > $scope.ball.options.pos.y )

								$scope.ball.options.speed.x *= -1
								$scope.ball.options.speed.x += 1
								$scope.ball.options.speed.y += 1
								canvasService.socket.emit 'ballMoved', $scope.ball

						updateRemoteBall : (ball)=>

							$scope.ball.options.pos.x = ball.options.pos.x
							$scope.ball.options.pos.y = ball.options.pos.y
							# $scope.ball.draw($scope.canvas)
							# @drawBall()

						createBall : =>

							$scope.ball = new BallModel()
							$scope.ball.draw($scope.canvas)

						setupControls : =>

							$(document).on 'keydown', (e)=>
								if e.keyCode is 38 or e.keyCode is 40
									$scope.localPlayer.update e.keyCode
									canvasService.socket.emit 'playerMoved', $scope.localPlayer, e.keyCode
														

					new gameStage
			]
			link : (scope, elem, attrs, ctrl)->

				scope.stage = elem[0]
				scope.canvas = scope.stage.getContext('2d')

				ctrl.init($(elem).width(), $(elem).height())

				canvasService.socket.on 'createPlayer', (player)->
					if player.type is 1
						ctrl.createPlayer player
					else if player.type is 2
						ctrl.createPlayer player	

				canvasService.socket.on 'startGame', ->
					ctrl.startGame()

				canvasService.socket.on 'playerMoved', (player, keyCode)->
					ctrl.updatePlayer player
					
				canvasService.socket.on 'ballMoved', (ball)->
					ctrl.updateRemoteBall ball

				
		}



	]