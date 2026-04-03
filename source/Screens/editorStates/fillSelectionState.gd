extends "res://addons/fsmgear/source/FsmState.gd"

func enter(actowner):
	super(actowner)
	actowner.mainMenu.hide()
	actowner.placingMenu.hide()
	actowner.fillMenu.show()
	
	
func update(actowner,delta):
	pass

func handleInput(actowner, event):
	if Input.is_action_just_pressed("ui_action"):
		var choice=  actowner.fillMenu.get_current_action()
		match choice:
			
			"exit":
				print("back to menu")
				actowner.exit_editor()
			_:
				actowner.fill_map(choice)
