extends Control


var op=0
var lastOp=2
@export var defaultOptions=["move","atk","wait"]
@onready var cursor=$cursor
@onready var actionsEnabled=[true,true,true]

# Called when the node enters the scene tree for the first time.
func _ready():
	op=0
	for defOp in defaultOptions:
		var lbl = Label.new()
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.text = defOp
#		lbl.align = Label.ALIGNMENT_CENTER
		$options.add_child(lbl)
	update_cursor_pos()
	pass # Replace with function body.

func set_actions_from_units(unit):
	actionsEnabled=unit.actEnabled
	var i=0	
	for e in actionsEnabled:
		if(e):
			print("+")
			print($options.get_child(i).text)
			$options.get_child(i).show()
		else:
			print("-")
			print($options.get_child(i).text)
			$options.get_child(i).hide()
		i+=1

func _process(delta):
	if(visible):
		if(Input.is_action_just_pressed("ui_up")):
			move_up()
		if(Input.is_action_just_pressed("ui_down")):
			move_down()

func move_down():
	op+=1
	if op>lastOp:
		op=0
		if(!actionsEnabled[op]):
			move_down()
	update_cursor_pos()

func move_up():
	op-=1
	if op<0:
		op=2
		if(!actionsEnabled[op]):
			move_up()
	update_cursor_pos()

func update_cursor_pos():
	var opLBL= $options.get_child(op)
	cursor.position = opLBL.get_begin()+Vector2(16,opLBL.get_line_height()/2)

func get_current_action():
	hide()
	var optionLBL= $options.get_child(op)
	return optionLBL.text

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
