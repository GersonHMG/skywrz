extends ColorRect

#Numero de casillas
var slot_number = 6
#int de la tecla seleccionada
var current_key = 0

onready var inventory = self.get_parent()
#slot nodes without children
onready var slot_nodes = get_node("GridContainer")

func _physics_process(delta):
#	key_input()
	pass
func _ready():
	var slot = load("res://Game_scenes/Hud/Inventory/slot_container.tscn")
	#Añade las respectivas casillas
	for i in slot_number:
		var SLOT = slot.instance()
		get_node("GridContainer").add_child(SLOT)
		SLOT.name = str(i+1)


#Deseleccionar visualmente todos los otros slots
func _deselect(prev_slot, select_slot):
	slot_nodes.get_node(prev_slot).select(false)

##### VER ESTO
#Seleccion de un nodo con las teclas 1,2,3...

func _input(event):
	if event is InputEventKey and event.pressed:
		#Si presiona una tecla numerica del 1 al 6
		if event.scancode in [49,50,51,52,53,54,55]:
			var prev_key = current_key
			if prev_key != 0:
				_deselect(str(prev_key),str(current_key))
			current_key = event.scancode - 48
			var slot = slot_nodes.get_node(str(current_key))
			slot.select(true)
			

func current_item():
	if current_key != 0:
		return slot_nodes.get_node(str(current_key)).item_name
