extends TextureRect


#Crea los containers en el inventario oculto
func _ready():
	var slot = load("res://Game_scenes/Hud/Inventory/slot_container.tscn")
	for i in 16:
		get_node("GridContainer").add_child(slot.instance())


