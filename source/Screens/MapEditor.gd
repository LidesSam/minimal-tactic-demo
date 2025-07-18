extends Control

@onready var tilemap
@onready var roomOptionsMenu= $CanvasLayer/RoomOptions
@onready var cursor= $cursor
@onready var fsm= $fsm

func _ready():
	new_map()
	Global.world=self
	fsm.autoload(self)
	fsm.startState()
	cursor.mode=cursor.EDITORMODE
	cursor.move=false

func exit_editor():
	get_tree().change_scene_to_file("res://source/Screens/MainMenu.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fsm.fsmUpdate(delta)
func _input(event: InputEvent) -> void:
	fsm.handleInput(event)
func save_map():
	pass

func fill_map():
	for x in range(16):
		for y in range(12):
			#tilemap.set_cell(0,Vector2i(x,y),1)
			pass
	pass
func new_map():
	fill_map()
