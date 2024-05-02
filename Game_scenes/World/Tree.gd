extends StaticBody2D

var loot = 10
var health_points = 20

func _ready():
	pass # Replace with function body.

func damage(dmg = 0):
	$Tree_sprite.play("hit")
	health_points -= dmg

func _on_Tree_sprite_animation_finished():
	$Tree_sprite.play("default")
	if health_points <= 0:
		drop_items()
		self.queue_free()

func drop_items():
	var wood = load( "res://Game_scenes/Items/wood.tscn"   )
	for i in range(loot):
		var wood_item = wood.instance()
		node_reference.ITEMS.add_child(wood_item)
		var to_pos = self.position + Vector2(10,80)
		randomize()
		var randnum = randi()%80
		wood_item.position = self.position
		wood_item.area_drop(self)

		
