extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var onTurnMenu=false
var onConfirm=false
var mode=""
var state=""
func _ready():
	super()	

func enter(actowner):
	super(actowner)
	onTurnMenu=false
	actowner.cursor.canMove=true
	onConfirm=false
	state=""	

func update(actowner,delta):
	pass

func handleInput(actowner,event):
	match (state):
		"onturnmenu":
			if Input.is_action_just_pressed("ui_action"):
				mode = actowner.turnActMenu.get_current_action()
				print("mode:",mode)
				match mode:
					"end turn":
						endstate=true
						actowner.turnGroup="alphablue"
						
			if Input.is_action_just_pressed("ui_accept"):
				actowner.turnActMenu.hide()
				actowner.cursor.canMove=true	
				state=""
				
			if Input.is_action_just_pressed("ui_back"):
				actowner.turnActMenu.hide()
				actowner.cursor.canMove=true
				state=""
		_:
			if Input.is_action_just_pressed("ui_action"):
				if(actowner.select_hover_unit()):
					actowner.display_unit_actions()
					
			if Input.is_action_just_pressed("ui_accept"):
				actowner.turnActMenu.show()
				state="onturnmenu"
				actowner.cursor.canMove=false	
				
			
				
	#actowner.reset_hover_unit()			
	pass

func state_ended():
	return endstate
	
func exit(actowner):
	actowner.turnActMenu.hide()
	onTurnMenu=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
