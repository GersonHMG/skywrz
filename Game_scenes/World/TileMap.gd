extends TileMap

#FUNCIONAMIENTO: el script para construir tiene dos partes:
#tile_selection() seleccion los tiles y los pinta de un color con el nodo
#selection tool
#build() se encarga de construir al presionar click y gastarle el item al jugador

#Selection tool
export (Color, RGBA) var green
export (Color, RGBA) var red
export (Color, RGBA) var transparent
var current_color = green
var tile
onready var SELECTION_TOOL = get_node("SelectionTool")
var is_buildable = false
var can_build = false

#SINGLEPLAYER: SELECCION DEL NODO JUGADOR
onready var PLAYER = get_parent().get_node("Players/Character")
var player_state


func _process(delta):
	player_state = PLAYER.PLAYER_STMA.state
	#Si el jugador esta construyendo
	if PLAYER.is_building():
		SELECTION_TOOL.visible = true
		can_build()
		tile_selection()

	else:
		SELECTION_TOOL.visible = false

#EDITARLO PARA OTROS BLOQUES
func build():
	var player_object = PLAYER.current_item	#Nombre del objeto que porta el player
	var structure  = load("res://Game_scenes/Buildings/"+player_object+".tscn")
	var pos = map_to_world(tile)
	var box = structure.instance()
	box.rotation_degrees = SELECTION_TOOL.get_node("item").rotation_degrees
	box.position = pos
	$Buildings.add_child(box)
	PLAYER.remove_current_item(player_object)
	#Para que no se acople
	#set_cellv(tile, 140)

func tile_selection():	#Es el cursor arriba de los tiles
	var mouse_pos = get_global_mouse_position()
	tile = world_to_map(mouse_pos)
	SELECTION_TOOL.position = map_to_world(tile)
	SELECTION_TOOL.get_node("item").modulate = transparent
	var item_texture = load("res://Art_resources/Items/"+PLAYER.current_item+".png")
	SELECTION_TOOL.get_node("item").texture = item_texture
	#TILE SET 2:ARENA , 3: AGUA
	#CAMBIARLO PARA EL MULTIPLAYER
	if get_cellv(tile) == 2 and can_build:
		current_color = green
		is_buildable = true
	else:
		current_color = red
		is_buildable = false
	SELECTION_TOOL.get_node("Sprite").material.set_shader_param("current_color", current_color)

func _input(event):
	if PLAYER.is_building():
		if event.is_action_pressed("mouse_click") and is_buildable:
			build()
		if event.is_action_pressed("R"):
			SELECTION_TOOL.get_node("item").rotation_degrees += 90

func can_build():	#Determina el rango de construccion
	var vector =  SELECTION_TOOL.global_position - PLAYER.position
	if vector.length() < 122:
		can_build = true
	else:
		can_build = false
