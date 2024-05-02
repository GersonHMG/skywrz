extends Position2D

var can_hit = true



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Punch_delay_timeout():
	can_hit = true
	$Area2D/CollisionShape2D.disabled = false


func _on_Area2D_body_entered(body):
	if body.has_method("hit") and can_hit:
		print("Entro")
		can_hit = false
		body.hit()
		$Area2D/CollisionShape2D.disabled = true
