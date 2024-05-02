extends RayCast2D

var can_hit = true
var damage = 10

onready var CHARACTER_NODE = self.get_parent().get_parent()

func _ready():
	#Excepcion para que no colisione con el jugador
	self.add_exception(CHARACTER_NODE)
	
func _physics_process(delta):
	self.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("mouse_click"):
		self.hit()

func hit():
	$hit.play("hit")
	if self.is_colliding() and can_hit:
		can_hit = false
		var collider = self.get_collider()
		if collider.has_method("damage"):
			collider.call("damage",damage)

func _on_Punch_delay_timeout():
	can_hit = true
