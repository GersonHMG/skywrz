extends Area2D


var SPEED = 800
var damage = 50

var direction = Vector2()



func _ready():
	#Para que sea independiente del arma
	set_as_toplevel(true)

func _process(delta):
	#Movimiento de la bala
	position.x += direction.x * SPEED * delta
	position.y += direction.y * SPEED * delta


func _on_Timer_timeout():
	#Se elimina despues de un cierto tiempo
	self.queue_free()



func _on_bullet_area_entered(area):
	print("entrooo")
	if area.has_method("damage"):
		area.call("damage",damage)
		self.queue_free()

func _on_bullet_body_entered(body):
	if body.has_method("damage"):
		body.call("damage",damage)
		self.queue_free()
