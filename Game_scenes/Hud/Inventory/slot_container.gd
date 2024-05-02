extends Panel

#---Nodes path---#
onready var item_node = get_node("z_index/item")

#----Informacion de la celda---#
var item_name = "void"		#Nombre del item contenido
var item_quantity = 0		#Cantidad del item contenido
var max_stack = 0			#Maximo stack de la celda
var item_texture = null		#Texutura del item

onready var SLOT_SPRITE = $slot_sprite

func _ready():
	update_item()
	empty_slot()

func on_get_item(quantity):
	item_quantity += quantity

#Actualiza visualmente las ventanas de texto e imagenes
func update_item():
	if item_name != "void":
		item_texture = load("res://Art_resources/Items/"+item_name+".png")
	else:
		item_texture = null
	item_node.get_node("item_quantity").text = str(item_quantity)
	item_node.get_node("item_name").text = item_name
	item_node.get_node("item_sprite").texture = item_texture

#Limpia la casilla internamente.
func empty_slot():
	item_quantity = 0
	item_name = "void"
	max_stack = 0
	item_texture = null
	update_item()

#on_give_item(Objeto que cae a la casilla, modo de entrega (click derecho o izq)
func on_give_item(object_referece, give_mode):
	#           = area2D -> item -> slot_container
	######
	print("on_give_item()")
	var object = object_referece
	if (object.has_method("on_get_item")):
		#Si la casilla contiene el mismo objeto
		if object.item_name == item_name:
			#Cantidad faltante
			var missing_quantity = object.max_stack - object.item_quantity
			#Si es un drop de todo el objeto
			if give_mode == "normal_drop":
				#Si hay espacio para el drop
				if item_quantity <= missing_quantity:
					#Se dropea todo
					object.on_get_item(item_quantity)   #Lo que recive
					item_quantity -= item_quantity		#Lo que entrega
				#Si no hay espacio para el drop
				else:
					#Se dropea lo faltante
					object.on_get_item(missing_quantity) #Lo que recive
					item_quantity -= missing_quantity	 #Lo que entrega
			#Si es un drop de click derecho (por unidad)
			elif give_mode == "unity_drop":
				if item_quantity > 0 and (object.item_quantity < object.max_stack):
					object.on_get_item(1)				#Lo que recive
					item_quantity -= 1					#Lo que entrega
		#Si la casilla esta vacia
		elif object.item_name == "void":
			object.item_name = item_name
			object.max_stack = max_stack
			object.item_texture = item_texture
			if give_mode == "normal_drop":
				object.on_get_item(item_quantity)	    #Lo que recive
				item_quantity -= item_quantity			#Lo que entrega
			elif give_mode == "unity_drop":
				if item_quantity > 0:
					object.on_get_item(1)				#Lo que recive
					item_quantity -= 1       			#Lo que entrega
		elif object.item_name != item_name:
			swap_items(object)
			pass
	#Si no hay nada entonces el slot se resetea a vacio
		if item_quantity <= 0:
			empty_slot()
		#Actualizacion de las casillas
		object.update_item()
		update_item()

func swap_items(object):
	var temp_name = object.item_name
	var temp_stack = object.max_stack 
	var temp_text = object.item_texture
	var temp_quant = object.item_quantity
	object.item_name = item_name
	object.max_stack = max_stack
	object.item_texture = item_texture
	object.item_quantity = item_quantity
	item_name = temp_name
	max_stack = temp_stack
	item_texture = temp_text
	item_quantity = temp_quant

func add_item(new_name, new_stack):
	item_name = new_name
	max_stack = new_stack
	item_quantity += 1
	update_item()


#Cambia el colro del slot
func select(flag):
	if flag:
		SLOT_SPRITE.modulate = Color(0,100,100,1)
	else:
		SLOT_SPRITE.modulate = Color(1,1,1,1)
