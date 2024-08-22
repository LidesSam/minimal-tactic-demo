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
		$options.add_child(lbl)
	update_cursor_pos()
	pass # Replace with function body.

func set_actions_from_units(unit):
	actionsEnabled = unit.actEnabled
	var i = 0	
	for e in actionsEnabled:
		if e:
			$options.get_child(i).show()
		else:
			$options.get_child(i).hide()
		i += 1
	set_on_first_enabled()  # Set the cursor to the first enabled option
	update_cursor_pos()

func set_on_first_enabled():
	op=0
	for i in range(actionsEnabled.size()):
		if actionsEnabled[i]:
			op = i
			print("i:",i)
			return

func _process(delta):
	if(visible):
		if(Input.is_action_just_pressed("ui_up")):
			prev_action()
		if(Input.is_action_just_pressed("ui_down")):
			next_action()
	$Label.text=str(op)
	var optionLBL= $options.get_child(op)

	$Label2.text=optionLBL.text

func next_action():
	op+=1
	if op>lastOp:
		op=0
	if(!actionsEnabled[op]):
		next_action()
	update_cursor_pos()
	

func prev_action():
	op-=1
	if op<0:
		op=2
	if(!actionsEnabled[op]):
		prev_action()
	update_cursor_pos()

func update_cursor_pos():
	print("op",op)
	var opLBL= $options.get_child(op)
	print("oplbl",opLBL," txt:",opLBL.text)
	cursor.position = opLBL.get_begin()+Vector2(16,opLBL.get_line_height()/2)
	
func get_current_action():
	hide()
	var optionLBL= $options.get_child(op)
	return optionLBL.text

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_options_sort_children():
	#adjsut cursor position after sort options
	#particulary when a options is disable(hide)
	update_cursor_pos()
