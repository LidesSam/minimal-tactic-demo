extends "res://addons/fsmgear/source/FsmState.gd"


func enter(actowner):
	super(actowner)
	actowner.mainMenu.show()
	actowner.placingMenu.hide()
	actowner.fillMenu.hide()
	
func update(actowner,delta):
	pass

func handleInput(actowner, event):
	if Input.is_action_just_pressed("ui_action"):
		match actowner.mainMenu.get_current_action():
			"fill":
				actowner.currentMenu=actowner.MENU.FILLER
			"edit":
				pass
			"exit":
				print("back to menu")
				actowner.exit_editor()
