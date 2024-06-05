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
			mode = actowner.turnActMenu.get_current_action()
			print("pt: mode:",mode)
			if(onTurnMenu):
				match(mode):
					"end turn":
						actowner.turnGroup="foeturn"
						onTurnMenu=false
					_:
						pass	
			else:
				if(actowner.select_hover_unit()):
					actowner.display_unit_actions()
	actowner.reset_hover_unit()
	
	if Input.is_action_just_pressed("ui_accept"):
		if(!onConfirm and onTurnMenu):
			actowner.turnActMenu.hide()
			onTurnMenu=false
			actowner.cursor.canMove=true
		else:
			actowner.turnActMenu.show()
			onTurnMenu=true
			actowner.cursor.canMove=false
			
	if Input.is_action_just_pressed("ui_back"):
		if(onConfirm):
			mode = actowner.turnActMenu.get_current_action()
			match(mode):
				_:
					pass
		else:
			actowner.turnActMenu.hide()
			actowner.cursor.canMove=true
	pass

func state_ended():
	return endstate
	
func exit(actowner):
	actowner.turnActMenu.hide()
	onTurnMenu=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
