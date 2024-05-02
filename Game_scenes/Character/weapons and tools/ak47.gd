extends Sprite


onready var position_one = get_node("Position2D")
onready var position_two = get_node("Position2D2")
var bullet_position = position_one
const BULLET = preload("res://Game_scenes/Character/weapons and tools/bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	self.look_at(get_global_mouse_position())
	if abs(fmod(rotation_degrees, 360)) < 90 or abs(fmod(rotation_degrees, 360)) > 270:
		flip_v = false
		bullet_position = position_one
	else:
		flip_v = true
		bullet_position = position_two
	if Input.is_action_just_pressed("mouse_click"):
		shoot()

func shoot():
	var bullet_direction = self.global_position - get_global_mouse_position()
	bullet_direction = -bullet_direction.normalized()
	var bullet = BULLET.instance()
	add_child(bullet)
	bullet.global_position = bullet_position.global_position
	bullet.direction = bullet_direction
