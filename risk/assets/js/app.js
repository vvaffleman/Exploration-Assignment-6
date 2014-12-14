var express = require('express'),
app = express(),
server = require('http').createServer(app),
io = require('socket.io').listen(server);

server.listen(1337);

app.get('/', function(req, res){
  res.sendFile(__dirname + '/views/static/index.ejs');
});

io.sockets.on('connection', function(socket){
  socket.on('send message', function(data){
    io.sockets.emit('new message', data);
    console.log(data);
    //Sends to everyone but sender
    //io.broadcast.emit('new message', data);
  });
});
