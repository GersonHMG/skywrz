extends Node

var item_data

func _ready():
	var itemdata_file = File.new()
	itemdata_file.open("res://Data/item_table.json",File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result
	print(item_data)
