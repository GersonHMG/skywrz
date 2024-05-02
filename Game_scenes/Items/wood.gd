extends Area2D

#¿Como funciona el codigo?
#Primero, si el jugador detecta el item entonces le manda una señal
#Para que el item vaya hacia el on_pick_up(who).
#Segundo el item hace la animacion hasta que llega al jugador
#_physic_proccess(delta)

#Segunda funcionalidad: DROP
#El item se dropea aleatoriamente

var item_name = "wood"
var pickup = false
var player = null

var can_pick = true


func _physics_process(delta):
	#Animacion de pickup y seguimiento al jugador
	if pickup:
		$AnimationPlayer.play("pickup")
		var player_pos = player.position
		$Tween.interpolate_property(self, "position", self.position, player_pos,0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
		$Tween.start()

#Cuando alguien toma el objeto
func on_pick_up(who):
	$CollisionShape2D.disabled
	player = who
	pickup = true


#-------Animation Drops----------------#
#Funciones unicamente de animacion

#Animacion de drop de un recurso.
func area_drop(who):
	randomize()
	var random_number = rand_range(-25,25)
	var random_position = who.position + Vector2(random_number,random_number)
	$AnimationPlayer.play("drop")
	$Tween.interpolate_property(self, "position", self.position, random_position,0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()

#Animacion de drop de un jugador, player_drop(inicio del drop, fin del drop)
func player_drop(obj_pos,vector):
	self.position = vector
	can_pick = false
	$CollisionShape2D.disabled = true
	$Timer.start()
	$AnimationPlayer.play("drop")
	$Tween.interpolate_property(self, "position", obj_pos, vector,0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()

#--------------------------------------#

#Cuando termina la animacion el objeto se elimina
func _on_AnimationPlayer_animation_finished(anim_name):
	#animacion de tomar objeto
	if anim_name == "pickup":
		self.queue_free()

func _on_Timer_timeout():
	$CollisionShape2D.disabled = false
	can_pick = true

func _on_Wood_body_entered(body):
	if body.has_method("pick_up_item"):
		if can_pick:
			body.pick_up_item(item_name)
			on_pick_up(body)
