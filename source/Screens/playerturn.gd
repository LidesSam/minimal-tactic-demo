extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false

func _ready():
	super()
	
	pass

func enter(actowner):
	super(actowner)
	
	actowner.cursor.canMove=true

func update(actowner,delta):
	
	pass

func handleInput(actowner,event):
	if Input.is_action_just_pressed("ui_action"):
			if(actowner.select_hover_unit()):
				actowner.display_unit_actions()
	actowner.reset_hover_unit()
	pass

func state_ended():
	return endstate

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
