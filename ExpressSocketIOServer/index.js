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
const cors = require('cors')


app.use(cors())

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

var players_data = {}

io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
  socket.on('player_update', (data) => {
    console.log(data)
    players_data[data.playerID] = data
    io.emit('all_players_update', players_data);
  })
});


server.listen(3000, () => {
  console.log('listening on *:3000');
});