extends state_machine



func _ready():
	#Add all states of the character
	add_state("idle")
	add_state("run")
	add_state("in_inventory")
	add_state("in_building")
	#Set initial state
	call_deferred("set_state", states.idle)

func _input(event):
#	if event.is_action_pressed("tab") and ![states.on_inventory].has(state):
#		set_state(2)
	pass 

func _state_logic(delta):
	parent._handle_move_input()
	if ![states.in_inventory].has(state):
		parent._apply_movement()
	parent.STATE_LABEL.text = str(state) + str(states.keys())
	
func _get_transition(delta):
	match state: 
		states.idle:
			if parent.movedir.x != 0:
				return states.run
			elif parent.movedir.y != 0:
				return states.run
			elif Input.is_action_just_pressed("tab"):
				return states.in_inventory
		states.run:
			if parent.movedir.x == 0 and parent.movedir.y == 0:
				return states.idle
			elif Input.is_action_just_pressed("tab"):
				return states.in_inventory
		states.in_inventory:
			if Input.is_action_just_pressed("tab"):
				return states.idle
	return null

#Cuando entra a un estado hace lo siguiente dependiendo del estado
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.CHARACTER_SPRITE.play("idle")
		states.run:
			parent.CHARACTER_SPRITE.play("walk")
		states.in_inventory:
			parent.INVENTORY.inventory_open()
	pass
	
func _exit_state(old_state, new_state):
	match old_state:
		states.in_inventory:
			parent.INVENTORY.inventory_open()
	pass  
