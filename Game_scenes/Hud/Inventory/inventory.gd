extends Control

#Global variables
var inventory_data = {}
onready var crafting_table = get_node("crafting_table")
onready var SLOT_BOX_PRIMARY = get_node("slot_box_primary")

var current_item = "void"

func inventory_open():
	if $slot_box.visible == true:
		$slot_box.visible = false
		$crafting_table.visible = false
	else:
		$slot_box.visible = true
		$crafting_table.visible = true

func drop_item(object, vector):
	#Eliminar item del inventario 
	#-Eliminar item del inventario visual
	#-Eliminar item del inventario interno
	#--Saber que item selecciono
	#Animacion de soltar item
	#obtener el item seleccionado por las casillas primarias
	var item_name = SLOT_BOX_PRIMARY.current_item()
	if item_name == "wood" or item_name == "stone":
		var item = load("res://Game_scenes/Items/"+item_name+".tscn").instance()
		#Obtener el nodo ITEMS,
		node_reference.ITEMS.add_child(item)
		var to_pos = object.position + vector
		remove_current_item()
		item.player_drop(object.position, to_pos)
		
	
#-------------- Dictionary functions-------------------------------#
#Añade un item al diccionario
func add_item(item_name, quantity):
	if inventory_data.has(item_name):
		inventory_data[item_name] += quantity
	else:
		inventory_data[item_name] = 1
		
func remove_item(item_name,quantity):
	if inventory_data.has(item_name):
		inventory_data[item_name] -= quantity
	else:
		inventory_data[item_name] = 0

#------------- Visual Inventory functions--------------------------#

#Añade un nuevo item al inventario
func add_item_inventory(item_name):
	var empty_slot = get_empty_slot(item_name)
	if empty_slot != null:
		empty_slot.add_item(item_name, import_data.item_data[item_name]["item_stack"])
		add_item(item_name,1)
	crafting_table.refresh_craft()

#Elimina un objeto en cualquier casilla y del inventario interno
func remove_item_inventory(item_name, quantity):
	remove_item(item_name,quantity)
	#Buscar item en el inventario general
	var slots_list = [get_node("slot_box/GridContainer"),get_node("slot_box_primary/GridContainer")]	
	for i in slots_list.size():
		for slot in slots_list[i].get_children():
			#Verificar si el item esta en este slot
			if slot.item_name == item_name:
				#Quitar cierta cantidad
				#Cuando el slot es igual a la cantidad que se quiere quitar
				if (slot.item_quantity <= quantity):
					quantity -= slot.item_quantity
					slot.empty_slot()
				else:
					slot.item_quantity -= quantity
					quantity = 0
					slot.update_item()
			if quantity <= 0:
				break
				
func remove_current_item():
	#Eliminar el item del diccionario
	current_item = get_current_item()
	print(current_item)
	if current_item != "void":
		remove_item(current_item,1)
		var slot = SLOT_BOX_PRIMARY.get_node("GridContainer/"+str(SLOT_BOX_PRIMARY.current_key))
		slot.item_quantity -= 1
		if slot.item_quantity <= 0:
			slot.empty_slot()
		slot.update_item()

#Obtener un slot vacio y retornalo
func get_empty_slot(item_name):
	var node
	#Primary inventory
	for i in $slot_box_primary/GridContainer.get_child_count():
		node = $slot_box_primary/GridContainer.get_child(i)
		if node.item_name == item_name and node.item_quantity < node.max_stack:
			return node
		elif node.item_name  == "void":
			return node
	for i in $slot_box/GridContainer.get_child_count():
		node = $slot_box/GridContainer.get_child(i)
		if node.item_name == item_name and node.item_quantity < node.max_stack:
			return node
		elif node.item_name  == "void":
			return node
	return null

#----get current item select ----------#

func get_current_item():
	return SLOT_BOX_PRIMARY.current_item()


#-------------- Developer Panel -------------#
func _on_add_item_pressed():
	randomize()
	var random_number = randi()%import_data.item_data.keys().size()+0
	var new_name = import_data.item_data.keys()[random_number] 
	add_item_inventory(new_name)
	$crafting_table.inventory_data = inventory_data
	$crafting_table.refresh_craft()

func _on_check_items_pressed():
	print(inventory_data)
