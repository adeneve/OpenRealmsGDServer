extends Node

var PORT:int = 2000
var MAX_CONNECTIONS:int = 30

var RSAVerificationDict = {}

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

	

#rpc to download assets, client needs to send websocket peerID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
	
@rpc("authority", "call_remote", "reliable")
func RSAPubKeyIsValid(valid):
	#decrypt on client side
	#and finally verify on server side
	pass
	
@rpc("any_peer", "call_remote", "reliable")
func sendDecryptedInt(dint):
	print("received int: " + str(dint))
	var sender_id = multiplayer.get_remote_sender_id()
	print("from sender_id: " + str(sender_id))
	#finally, if it matches send true, else false
	if RSAVerificationDict[sender_id] == dint:
		RSAPubKeyIsValid.rpc_id(sender_id, true)
	else:
		RSAPubKeyIsValid.rpc_id(sender_id, false)
	RSAVerificationDict.erase(sender_id)

	
@rpc("authority", "call_remote", "reliable")
func sendEncryptedInt(eint):
	#decrypt on client side
	#and finally verify on server side
	pass
	
@rpc("any_peer", "call_remote", "reliable")
func sendRSApubkey(publicKey):
	# The server knows who sent the input.
	print("received key: " + publicKey)
	var sender_id = multiplayer.get_remote_sender_id()
	print("from sender_id: " + str(sender_id))
	# Process the input and affect game logic.
	var rng = RandomNumberGenerator.new()
	var randomInt = rng.randi_range(0.0, 10000000)
	print(str(randomInt))
	#now encrypt it using pub key
	var k = CryptoKey.new()
	k.load_from_string(publicKey, true)
	var crypto = Crypto.new()
	var eint = crypto.encrypt(k, str(randomInt).to_utf8_buffer())
	print(eint)
	print("here")
	
	#get_string_from_utf8
	# store in dict, sender_id -> randomInt
	RSAVerificationDict[sender_id] = randomInt
	
	sendEncryptedInt.rpc_id(sender_id, eint)
	
	#later, erase sender_id
	#now generate a random int, then rpc back to this sender
	
	# 'sendEncryptedInt', store in dictionary (id, int)
	#call sendEncryptedInt with senderID as arg
	
	# then we should expect 'DecryptInt', that matches dictionary entry
	
func _on_player_connected(id):
	print("player connected with id: %s" % id)
	
func _on_player_disconnected(id):
	print("player disconnected with id: %s" % id)

