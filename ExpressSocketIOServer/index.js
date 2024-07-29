const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io")
const io = require("socket.io")(server, {
  cors: {
    origin: "*"
  }
});
const cors = require('cors');
const { SocketAddress } = require('net');


app.use(cors())

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

var players_data = {}

io.on('connection', (socket) => {
  console.log('a user connected');
  console.log(socket.id)
  players_data[socket.id] = {}
  socket.on('disconnect', () => {
    console.log('user disconnected');
    delete players_data[socket.id]
  });
  socket.on('player_update', (data) => {
    console.log(data)
    players_data[socket.id] = data
    io.emit('all_players_update', players_data);
  })
});


server.listen(3000, () => {
  console.log('listening on *:3000');
});