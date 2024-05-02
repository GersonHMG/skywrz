extends Node2D

var can_hit = true
var damage = 30
var mouse_direction_vector = Vector2()
onready var CHARACTER_NODE = self.get_parent().get_parent()
onready var SPRITE = $hand
onready var RAYCAST = $raycast
# Called when the node enters the scene tree for the first time.
func _ready():
	$raycast.add_exception(CHARACTER_NODE)
	#print(get_parent().get_node("Pocket_pickup"))
	pass
	
func _physics_process(delta):
	RAYCAST.look_at(get_global_mouse_position())
	sprite_rotation()
	if Input.is_action_just_pressed("mouse_click"):
		activate()
		

func activate():
	$hit.play("pickaxe_attack")
	
func sprite_rotation():
	mouse_direction_vector = get_global_mouse_position() - CHARACTER_NODE.position
	var angle = Vector2()
	angle = rad2deg(mouse_direction_vector.angle())
	if abs(angle) > 90:
		SPRITE.flip_h = false
	else:
		SPRITE.flip_h = true


	
func hit():
	if RAYCAST.is_colliding() and can_hit:
		print("IS COLLIG")
		can_hit = false
		var collider = RAYCAST.get_collider()
		if collider.has_method("damage"):
			collider.call("damage",damage)

func _on_Punch_delay_timeout():
	can_hit = true

func _on_hit_animation_finished(anim_name):
	if anim_name == "pickaxe_attack":
		hit()
