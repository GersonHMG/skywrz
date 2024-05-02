extends StaticBody2D

#Parametrs

var can_rotate = true


func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("R"):
		flip()

func flip():
	self.rotation_degrees += 90
