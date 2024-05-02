extends StaticBody2D

var loot_name = "stone"
var loot = 10
var health_points = 20
onready var sprite = get_node("sprite")

func _ready():
	pass # Replace with function body.

func damage(dmg = 0):
	sprite.play("hit")
	health_points -= dmg

func drop_items():
	var wood = load("res://Game_scenes/Items/stone.tscn")
	for i in range(loot):
		var wood_item = wood.instance()
		node_reference.ITEMS.add_child(wood_item)
		var to_pos = self.position + Vector2(10,80)
		randomize()
		var randnum = randi()%80
		wood_item.position = self.position
		wood_item.area_drop(self)


func _on_sprite_animation_finished():
	sprite.play("default")
	if health_points <= 0:
		drop_items()
		self.queue_free()
