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
	_server.send(-peer_id, "[%d] Says: %s" % [peer_id, message])


# UI signals.
func _on_send_pressed():
	if _line_edit.text == "":
		return

	info("Sending message: %s" % [_line_edit.text])
	_server.send(0, "Server says: %s" % _line_edit.text)
	_line_edit.text = ""


