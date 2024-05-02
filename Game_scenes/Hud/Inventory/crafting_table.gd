extends ColorRect


var inventory_data = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	#Crea el menu de crafting
	var slot = load("res://Game_scenes/Hud/Inventory/slot_craft.tscn")
	var items = import_data.item_data
	
	for i in items:
		if items[i]["item_type"] != "craft":
			var SLOT = slot.instance()
			get_node("ScrollContainer/VBoxContainer").add_child(SLOT)
			SLOT.create_recipe(i)
			SLOT.can_craft(!can_craft(i))
			SLOT.name = i

func refresh_craft():
	inventory_data = get_parent().inventory_data 
	for node in $ScrollContainer/VBoxContainer.get_children():
		node.can_craft(!can_craft(node.name))

func can_craft(item_name):
	var recipe = import_data.item_data[item_name]["recipe"]
	if recipe != null:
		for ingredient in recipe:
			#Comprobar si esta en el diccionario para los errores
			if inventory_data.has(ingredient):
				if inventory_data[ingredient] >= recipe[ingredient]:
					pass
				else:
					return false
			else:
				return false
		return true
	return false
	
func craft(item_name):
	get_parent().add_item_inventory(item_name)
	var recipe = import_data.item_data[item_name]["recipe"]
	for ingredient in recipe:
		get_parent().remove_item_inventory(ingredient, recipe[ingredient])
	refresh_craft()
	
