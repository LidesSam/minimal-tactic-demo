extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var onTurnMenu=false
var onConfirm=false
var mode=""
func _ready():
	super()
	
	pass

func enter(actowner):
	super(actowner)
	onTurnMenu=false
	actowner.cursor.canMove=true
	onConfirm=false

func update(actowner,delta):
	
	pass

func handleInput(actowner,event):
	if Input.is_action_just_pressed("ui_action"):
			if(actowner.select_hover_unit()):
				actowner.display_unit_actions()
	actowner.reset_hover_unit()
	
	if Input.is_action_just_pressed("ui_accept"):
		
		if(!onConfirm and onTurnMenu):
			actowner.turnActMenu.hide()
			onTurnMenu=false
		else:
			actowner.turnActMenu.show()
			onTurnMenu=true
	if Input.is_action_just_pressed("ui_back"):
		if(onConfirm):
			pass
		else:
			mode = actowner.turnActMenu.get_current_action()
			match(mode):
				_:
					pass
			actowner.turnActMenu.hide()
	pass

func state_ended():
	return endstate
func exit(actowner):
	actowner.turnActMenu.hide()
	onTurnMenu=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
