extends Node2D

var item_node
var players_node
func _ready():
	item_node = get_node("Items")
	players_node = get_node("Players")
	node_reference.ITEMS = item_node
	node_reference.PLAYERS = players_node
