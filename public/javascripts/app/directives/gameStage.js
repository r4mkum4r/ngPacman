// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

angular.module('pacman.directives').directive('gameStage', [
  'canvasService', '$compile', '$timeout', 'PlayerModel', 'BallModel', function(canvasService, $compile, $timeout, PlayerModel, BallModel) {
    return {
      controller: [
        '$scope', '$timeout', '$interval', 'canvasService', 'BallModel', function($scope, $timeout, $interval, canvasService, BallModel) {
          var gameStage;
          gameStage = (function() {
            function gameStage() {
              this.setupControls = __bind(this.setupControls, this);
              this.createBall = __bind(this.createBall, this);
              this.updateRemoteBall = __bind(this.updateRemoteBall, this);
              this.updateBall = __bind(this.updateBall, this);
              this.updatePlayers = __bind(this.updatePlayers, this);
              this.updatePlayer = __bind(this.updatePlayer, this);
              this.update = __bind(this.update, this);
              this.createPlayer = __bind(this.createPlayer, this);
              this.drawGameElements = __bind(this.drawGameElements, this);
              this.clearStage = __bind(this.clearStage, this);
              this.startGame = __bind(this.startGame, this);
              this.init = __bind(this.init, this);
            }

            gameStage.prototype.init = function(stageWidth, stageHeight) {
              this.gameConfig = {
                speedX: 2,
                speedY: 2
              };
              this.stage = {};
              this.userControl = {
                isDown: false,
                isTop: false
              };
              this.stage.height = stageHeight;
              this.stage.width = stageWidth;
              $scope.$canvas = $($scope.canvas);
              $scope.isLocalPlayerJoined = false;
              $scope.localPlayer = false;
              $scope.players = [];
              $scope.gameStarted = false;
              return '';
            };

            gameStage.prototype.startGame = function() {
              $scope.gameStarted = true;
              return this.createBall();
            };

            gameStage.prototype.clearStage = function() {
              return $scope.canvas.clearRect(0, 0, this.stage.width, this.stage.height);
            };

            gameStage.prototype.drawGameElements = function() {
              this.drawPlayers();
              if (this.player.posX < this.ball.posX + this.ball.radius && this.player.posX + this.player.width > this.ball.posX && this.player.posY < this.ball.posY + this.ball.radius && this.player.posY + this.player.height > this.ball.posY) {
                this.ball.speedX *= -1;
                return $timeout((function(_this) {
                  return function() {
                    _this.ball.speedX += 3;
                    return _this.player.speedX += 1;
                  };
                })(this), 50);
              }
            };

            gameStage.prototype.createPlayer = function(player) {
              var newPlayer;
              if (!$scope.localPlayer) {
                $scope.localPlayer = new PlayerModel(player);
                $scope.localPlayer.draw($scope.canvas);
              } else {
                newPlayer = new PlayerModel(player);
                newPlayer.draw($scope.canvas);
                $scope.players.push(newPlayer);
              }
              this.setupControls();
              return this.update();
            };

            gameStage.prototype.update = function() {
              this.clearStage();
              this.updatePlayers();
              if ($scope.ball) {
                this.updateBall();
              }
              return window.requestAnimFrame(this.update);
            };

            gameStage.prototype.updatePlayer = function(player) {
              if (!($scope.localPlayer.getId() === player.options.id)) {
                $scope.players[0].setX(player.options.pos.x);
                return $scope.players[0].setY(player.options.pos.y);
              }
            };

            gameStage.prototype.updatePlayers = function() {
              this.clearStage();
              if ($scope.localPlayer) {
                $scope.localPlayer.draw($scope.canvas);
              }
              if ($scope.players.length > 0) {
                return $scope.players[0].draw($scope.canvas);
              }
            };

            gameStage.prototype.updateBall = function() {
              if ($scope.localPlayer.options.isHost && $scope.gameStarted) {
                $scope.ball.update();
                canvasService.socket.emit('ballMoved', $scope.ball);
                $scope.ball.draw($scope.canvas);
              } else if ($scope.ball) {
                $scope.ball.draw($scope.canvas);
              }
              if ($scope.localPlayer.options.pos.x < $scope.ball.options.pos.x + $scope.ball.options.radius && $scope.localPlayer.options.pos.x + $scope.localPlayer.options.dimensions.width > $scope.ball.options.pos.x && $scope.localPlayer.options.pos.y < $scope.ball.options.pos.y + $scope.ball.options.radius && $scope.localPlayer.options.pos.y + $scope.localPlayer.options.dimensions.height > $scope.ball.options.pos.y) {
                $scope.ball.options.speed.x *= -1;
                $scope.ball.options.speed.x += 1;
                $scope.ball.options.speed.y += 1;
                return canvasService.socket.emit('ballMoved', $scope.ball);
              }
            };

            gameStage.prototype.updateRemoteBall = function(ball) {
              $scope.ball.options.pos.x = ball.options.pos.x;
              return $scope.ball.options.pos.y = ball.options.pos.y;
            };

            gameStage.prototype.createBall = function() {
              $scope.ball = new BallModel();
              return $scope.ball.draw($scope.canvas);
            };

            gameStage.prototype.setupControls = function() {
              return $(document).on('keydown', (function(_this) {
                return function(e) {
                  if (e.keyCode === 38 || e.keyCode === 40) {
                    $scope.localPlayer.update(e.keyCode);
                    return canvasService.socket.emit('playerMoved', $scope.localPlayer, e.keyCode);
                  }
                };
              })(this));
            };

            return gameStage;

          })();
          return new gameStage;
        }
      ],
      link: function(scope, elem, attrs, ctrl) {
        scope.stage = elem[0];
        scope.canvas = scope.stage.getContext('2d');
        ctrl.init($(elem).width(), $(elem).height());
        canvasService.socket.on('createPlayer', function(player) {
          if (player.type === 1) {
            return ctrl.createPlayer(player);
          } else if (player.type === 2) {
            return ctrl.createPlayer(player);
          }
        });
        canvasService.socket.on('startGame', function() {
          return ctrl.startGame();
        });
        canvasService.socket.on('playerMoved', function(player, keyCode) {
          return ctrl.updatePlayer(player);
        });
        return canvasService.socket.on('ballMoved', function(ball) {
          return ctrl.updateRemoteBall(ball);
        });
      }
    };
  }
]);
