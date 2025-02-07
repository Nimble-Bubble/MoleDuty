extends Button

var WhereToGo;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_pressed():
	WhereToGo = "res://Areas/MiScellanea/MS_testBC1.tscn"
	get_tree().change_scene_to_file(WhereToGo)
