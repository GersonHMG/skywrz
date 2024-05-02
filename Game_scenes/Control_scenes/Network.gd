extends Control

const PORT = 5003
const MAX_PLAYERS = 10

# ID : []
var players_on_server = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
#	get_tree().connect("server_disconnected", self, "_server_disconnected")

#------------- Server -----------------#
func host_server():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(server)
	self.players_on_server[get_tree().get_network_unique_id()] = []
	update_player_list(players_on_server)
	
func _player_connected(id):
	self.players_on_server[id] = []
	rpc("update_player_list",players_on_server)
	update_player_list(players_on_server)

func _player_disconnected(id):
	self.players_on_server.erase(id)
	rpc("update_player_list",players_on_server)
	update_player_list(players_on_server)

#------------- Client ------------------#
func join_server(server_ip):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(server_ip, PORT)
	get_tree().set_network_peer(host)

func _connected_ok():
	pass

func _connected_fail():
	#Error
	pass


#----------Control de interfaz ---------#
puppet func update_player_list(players_list):
	print(players_list)
	print("update_player_list")
	$Panel/Players_list.clear()
	for player in players_list:
		$Panel/Players_list.add_item(str(player))

func normal_state():
	$Join.visible = true
	$Host.visible = true
	$Start.visible = false


#-------------Buttons ------------------#
func _on_Host_pressed():
	host_server()
	$Start.visible = true
	$Join.visible = false

func _on_Join_pressed():
	var server_ip = $Ip_label/Ip_edit.text
	join_server(server_ip)
	$Host.visible = false

func _on_Start_pressed():
	print(players_on_server) 
	pass # Replace with function body.
