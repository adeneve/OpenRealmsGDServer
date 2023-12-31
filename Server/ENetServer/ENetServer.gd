extends Node

var PORT:int = 2000
var MAX_CONNECTIONS:int = 30


# Called when the node enters the scene tree for the first time.
func _ready():
	print("setting up ENet server: port " + str(PORT))
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
	
func _on_player_connected(id):
	print("player connected with id: %s" % id)
	
func _on_player_disconnected(id):
	print("player disconnected with id: %s" % id)

