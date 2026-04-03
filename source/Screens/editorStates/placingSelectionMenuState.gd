extends "res://addons/fsmgear/source/FsmState.gd"

func enter(actowner):
	super(actowner)
	
	
func update(actowner,delta):
	pass

func handleInput(actowner, event):
	if Input.is_action_just_pressed("ui_action"):
		match actowner.roomOptionsMenu.get_current_action():
			"exit":
				print("back to menu")
				actowner.exit_editor()
