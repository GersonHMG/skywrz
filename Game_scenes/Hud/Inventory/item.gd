extends Panel

#--------- Item node path ----------#
onready var slot_node = self.get_parent().get_parent()
onready var detection_node = slot_node.get_node("detection")
#Estados
#ESTA SIENDO ARRASTRADO
var is_drag = false
#EL MOUSE ESTA EN EL PANEL
var mouse_entered = false
#ESTA EN UNA CELDA AJENA
var in_other_box = false
#Informacion de posicion y area dentro
var start_position = rect_position
var current_area


####REVISAR ESTO
func _ready():
	#start_position = rect_position
	pass
	

#Aca se produce el arrastre del objeto
func _process(delta):
	#Si es una celda vacia no se arrastra
	if slot_node.item_name != "void":
		#Si el mouse esta en el panel y se presiona click izquierdo
		if mouse_entered and Input.is_action_pressed("mouse_click"):
			is_drag = true
			#Mueve el panel a la posicion del mouse
			rect_position = get_parent().get_local_mouse_position() - Vector2(25,25)
			#Le da visibilidad sobre los otros objetos (Para que se vea encima)
			get_parent().z_index = 1
		#Si lo deja de arrastrar o no lo esta arrastrando
		else:
			
			#Si lo estaba arrastrando y lo suelta
			if in_other_box:
				#slot_container.on_give_item
				get_parent().get_parent().on_give_item(current_area,"normal_drop")
			is_drag = false
			rect_position = start_position
			get_parent().z_index = 0
#Soluciona un bug de superposicion			
	else:
		is_drag = false
		rect_position = start_position
		get_parent().z_index = 0

#-------------Señales de estado-----------#
func _on_item_mouse_entered():
	mouse_entered = true

func _on_item_mouse_exited():
	mouse_entered = false
#-----------------------------------------#
func _on_Area2D_area_entered(area):
	#Si se esta arrastrando y entra a un area detection
	if is_drag and area.name == "detection" and area != detection_node:
		print(area, "Nombre del area: ", area.name)
		in_other_box = true
		current_area = area.slot_node

func _on_Area2D_area_exited(area):
#	if area != get_parent().get_parent().get_node("detection"):
	in_other_box = false
	current_area = null

func _on_item_gui_input(event):
	#Detecta un input del mouse
	if event is InputEventMouseButton:
		#Si el mouse esta en otra caja y se presiona click derecho
		if event.is_action_pressed("mouse_click2") and in_other_box:
			self.get_parent().get_parent().on_give_item(current_area,"unity_drop")
