extends KinematicBody2D

#Parametros de movimiento
var movedir = Vector2(0,0)
var speed = 150
var direction_state = "LEFT"

var current_item = "void"
var current_weapon = "hands"

#Si tiene equipado un objeto de construccion
var in_building = false
var mouse_direction_vector = Vector2()


#REFERECIAS A NODOS
onready var WEAPON_NODE = get_node("weapon")
onready var STATE_LABEL = get_node("Panel/Label")
onready var INVENTORY = get_node("Hud/inventory")
onready var CHARACTER_SPRITE = get_node("Sprite")
onready var PLAYER_STMA = get_node("state_machine")

func _physics_process(delta):
	num_input()
	#Hace que el sprite se gire dependiendo la posicion del mouse
	player_rotate_sprite()
	#Dropea el objeto recurrente
	if Input.is_action_just_pressed("Q"):
		#Convertir grados a radianes
		var grad = mouse_direction_vector.angle()
		#Funcion drop
		INVENTORY.drop_item(self, Vector2(50,0).rotated(grad))
	check_current_item()

#--------------MOVEMENT-------------------#
func _handle_move_input():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN =  Input.is_action_pressed("ui_down")
	if LEFT:
		direction_state = "LEFT"
	elif RIGHT:
		direction_state = "RIGHT"
	elif UP:
		direction_state = "UP"
	elif DOWN:
		direction_state = "DOWN"
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
func _apply_movement():
	var motion = movedir.normalized()*speed
	move_and_slide(motion, Vector2(0,0))
#Visual movement
func player_rotate_sprite():
	mouse_direction_vector = get_global_mouse_position() - self.position
	if rad2deg(mouse_direction_vector.angle()) > -90 and rad2deg(mouse_direction_vector.angle()) < 90:
		CHARACTER_SPRITE.flip_h = false
	else:
		CHARACTER_SPRITE.flip_h = true
#-----------------------------------------#
	

func remove_current_item(item):
	INVENTORY.remove_current_item()

func is_building():
	current_item = INVENTORY.get_current_item()
	if current_item != "void" and current_item != null:
		if import_data.item_data[current_item]["item_type"] == "building":
			return true
	return false
	
#Inventory function
#Agrega un item al inventario del jugador
func pick_up_item(item_name):
	if INVENTORY.get_empty_slot(item_name) != null:	#Slot disponible
		INVENTORY.add_item_inventory(item_name)

func num_input():
	#Si se presiona una tecla numerica del 1 al 6 
	if Input.is_action_just_pressed("NUM_KEY"):
		current_item = INVENTORY.get_current_item()
		#SI EL ARMA SE PUEDE EQUIPAR
		if current_item == "void" or import_data.item_data[current_item]["item_type"] == "craft":
			#Le entrega el arma principal (manos)
			if current_weapon != "hands":
				clear_out_weapons()
				var weapon = load("res://Game_scenes/Character/weapons and tools/Hands.tscn").instance()
				WEAPON_NODE.add_child(weapon)
				current_weapon = "hands"
		#Si es un objeto usable
		elif current_item == "pickaxe":
			clear_out_weapons()
			var weapon = load("res://Game_scenes/Character/weapons and tools/pickaxe.tscn").instance()
			WEAPON_NODE.add_child(weapon)
			current_weapon = "pickaxe"
		elif current_item == "ak47":
			clear_out_weapons()
			var weapon = load("res://Game_scenes/Character/weapons and tools/ak47.tscn").instance()
			WEAPON_NODE.add_child(weapon)
			current_weapon = "ak47"
		#SI EL OBJETO ES DE CONSTRUCCION
		elif import_data.item_data[current_item]["item_type"] == "building":
			print("buildable")
			in_building = true
			return
		in_building = false


func clear_out_weapons():
	for node in WEAPON_NODE.get_children():
		node.queue_free()
			


func check_current_item():
	current_item = INVENTORY.get_current_item()
	pass
