extends Panel

var item = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func create_recipe(item_name):
	item = item_name
	$item_name.text = item_name

func can_craft(flag):
	$craft_button.disabled = flag


func _on_craft_button_pressed():
	get_parent().get_parent().get_parent().craft(self.name)
	pass
