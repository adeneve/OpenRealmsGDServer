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
	
	
@rpc("any_peer", "call_remote", "reliable")
func sendRSApubkey(publicKey):
	# The server knows who sent the input.
	print("received key: " + publicKey)
	var sender_id = multiplayer.get_remote_sender_id()
	print("from sender_id: " + str(sender_id))
	# Process the input and affect game logic.
	#now generate a random int, then rpc back to this sender
	# 'sendEncryptedInt', store in dictionary (id, int)
	# then we should expect 'DecryptInt', that matches dictionary entry
	
func _on_player_connected(id):
	print("player connected with id: %s" % id)
	
func _on_player_disconnected(id):
	print("player disconnected with id: %s" % id)

