extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var op=0
@onready var options=[
		$mainScreen/newGameBtn,
		$mainScreen/mapEditBtn
		]
# Called when the node enters the scene tree for the first time.
func _ready():
	set_cursor_pos()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if(Input.is_action_just_pressed("ui_up")):
		op-=1
		if(op<0):
			op=options.size()-1
		set_cursor_pos()
	if(Input.is_action_just_pressed("ui_down")):
		op+=1
		if(op>=options.size()):
			op=0
		set_cursor_pos()
	if(Input.is_action_just_pressed("ui_action")):
		options[op].emit_signal("pressed")
func set_cursor_pos():
	print("set")
	$cursor.global_position=options[op].global_position
	pass

func _on_new_game_btn_pressed():
	get_tree().change_scene_to_file("res://source/Screens/World.tscn")
	pass # Replace with function body.


func _on_map_edit_btn_pressed():
	get_tree().change_scene_to_file("res://source/Screens/MapEditor.tscn")
	pass # Replace with function body.
