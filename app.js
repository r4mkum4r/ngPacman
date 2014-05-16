var express = require('express');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var routes = require('./routes/index');
var users = require('./routes/users');

var app = express(),
    playersStatus = {
        isPlayerOneJoined : false,
        isPlayerTwoJoined : false,
        isPlayerThreeJoined : false
    }
    players = [],
    Player = require('./host/player');


// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(favicon());
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/users', users);

/// catch 404 and forwarding to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});

var server = app.listen(3000, function() {
    console.log('Listening on port %d', server.address().port);
});

var io = require('socket.io').listen(server);

io.sockets.on('connection', function(client){

    if(players.length >= 3){
        return;
    }

    var newPlayer = new Player();

    newPlayer.id = client.id;
    newPlayer.pos = {
        x : 0,
        y : 0
    }

    if(playersStatus.isPlayerOneJoined === false){
        newPlayer.type = 1;
        newPlayer.isHost = true;
        playersStatus.isPlayerOneJoined = true;
    }
    else
    if(playersStatus.isPlayerTwoJoined === false)
    {
        newPlayer.type = 2;
        newPlayer.pos.x = 1090;
        newPlayer.isHost = false;
        playersStatus.isPlayerTwoJoined = true;
    }

    this.emit('createPlayer', newPlayer);
    
    for(var i=0; i < players.length; i++){
        client.emit('createPlayer', players[i]);
    }

    players.push(newPlayer);

    if(players.length === 2){
        io.sockets.emit('startGame');
    }

    client.on('disconnect', function(){
        for(var i=0; i< players.length; i++){
            if(players[i].id === this.id){
                if(players[i].type === 1){
                    playersStatus.isPlayerOneJoined = false;
                }
                else
                    if(players[i].type === 2){
                        playersStatus.isPlayerTwoJoined = false;
                    }
                players.splice(i);
                break;
            }
        }
    });

    client.on('playerMoved', function(player,keyCode){
        io.sockets.emit('playerMoved', player, keyCode);
    });

    client.on('ballMoved', function(ball){
        client.broadcast.emit('ballMoved', ball);
    });

});

module.exports = app;
