extends Node

@onready var _server: WebSocketServer = $WebSocketServer
@onready var _log_dest = "TODO"
@onready var _line_edit = "from websocketserver: test"
@onready var _listen_port = 2001


func _ready():
	var port = _listen_port
	var err = _server.listen(port)
	if err != OK:
		info("Error listing on port %s" % port)
		return
	info("WebSocket Server Listing on port %s, supported protocols: %s" % [port, _server.supported_protocols])

func info(msg):
	print(msg)

const scn = preload("res://scene.gltf")

#send serialized 3d files to peer
func sendResources(peer_id):
	var gltd = GLTFDocument.new()
	var gltfs = GLTFState.new()
	#gltd.append_from_file("res://scene.gltf",gltfs, 0, "")
	gltd.append_from_file("res://scene.gltf",gltfs)
	var byteArray = gltd.generate_buffer(gltfs)
	#first try to use glfDocument to load the scene here
	#locally at runtime
	#then do the same but simulate breaking apart the
	# array into buffer sizes and building it again
	#if that all works, then go back to testing network
	
	# chop buffer up into 8k segments
	#slice and send?
	#print(byteArray.size())
	#print(ArrayCompressed.size())
	#add a 50k padding if we go over? test that
	#adding padding of 0s is fine
	print(byteArray.size())
	var numPackets = (byteArray.size() / 64000) + 1
	print(numPackets)
	_server.send(peer_id, "packets " + str(numPackets))
	await get_tree().create_timer(3).timeout
	var sliceStart = 0
	var sliceEnd = 64000
	while sliceEnd <= byteArray.size():
		var subPack = byteArray.slice(sliceStart, sliceEnd)
		print(_server.peers[peer_id].get_current_outbound_buffered_amount())
		_server.send(peer_id, subPack)
		await get_tree().create_timer(0.15).timeout
		if sliceEnd >= byteArray.size():
			break
		sliceStart += 64000
		sliceEnd += 64000
		if sliceEnd >= byteArray.size():
			sliceEnd = byteArray.size()
	print("resource sent")
	
# Server signals
func _on_web_socket_server_client_connected(peer_id):
	var peer: WebSocketPeer = _server.peers[peer_id]
	info("Remote client connected: %d. Protocol: %s" % [peer_id, peer.get_selected_protocol()])
	_server.send(-peer_id, "[%d] connected" % peer_id)


func _on_web_socket_server_client_disconnected(peer_id):
	var peer: WebSocketPeer = _server.peers[peer_id]
	info("Remote client disconnected: %d. Code: %d, Reason: %s" % [peer_id, peer.get_close_code(), peer.get_close_reason()])
	_server.send(-peer_id, "[%d] disconnected" % peer_id)


func _on_web_socket_server_message_received(peer_id, message):
	info("Server received data from peer %d: %s" % [peer_id, message])
	#_server.send(-peer_id, "[%d] Says: %s" % [peer_id, message])
	match message:
		"sendresources":
			sendResources(peer_id)
			


# UI signals.
func _on_send_pressed():
	if _line_edit.text == "":
		return

	info("Sending message: %s" % [_line_edit.text])
	_server.send(0, "Server says: %s" % _line_edit.text)
	_line_edit.text = ""


