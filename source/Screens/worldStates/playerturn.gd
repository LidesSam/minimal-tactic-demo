extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var onConfirm=false
var mode=""



func _ready():
	super()	

func enter(actowner):
	super(actowner)
	actowner.cursor.canMove=true
	onConfirm=false

func update(actowner,delta):
	pass

func handleInput(actowner, event):
	if Input.is_action_just_pressed("ui_action"):
		if actowner.select_hover_unit():
			actowner.display_unit_actions()

	elif Input.is_action_just_pressed("ui_accept"):
		actowner.state =actowner. STATE_ON_TURN_MENU
			
				
	#actowner.reset_hover_unit()			
	pass

func state_ended():
	return endstate
	
func exit(actowner):
	actowner.turnActMenu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
