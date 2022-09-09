extends PopupPanel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var op=0
export var defaultOptions=["move","atk","wait"]
onready var cursor=$cursor
onready var actionsEnabled=[true,true,true]
# Called when the node enters the scene tree for the first time.
func _ready():
	op=0
	updateCursorPos()
	pass # Replace with function body.

func _process(delta):
	if(visible):
		if(Input.is_action_just_pressed("ui_up")):
			moveUp()
		if(Input.is_action_just_pressed("ui_down")):
			moveDown()

func moveDown():
	op+=1
	if op>2:
		op=0
	updateCursorPos()
	
func moveUp():
	op-=1
	
	if op<0:
		op=2
	updateCursorPos()
	
		
func updateCursorPos():
	var opLBL= $options.get_child(op)
	cursor.position = opLBL.get_begin()+Vector2(16,opLBL.get_line_height()/2)
	
func get_current_action():
	var optionLBL= $options.get_child(op)
	return optionLBL.text
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
