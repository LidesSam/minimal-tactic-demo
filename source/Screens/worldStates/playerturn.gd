extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var onTurnMenu=false
var onConfirm=false
var mode=""
var state=""

const STATE_IDLE = ""
const STATE_ON_TURN_MENU = "onturnmenu"
const STATE_INFO = "info"


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

func handleInput(actowner, event):
	match state:
		STATE_ON_TURN_MENU:
			if Input.is_action_just_pressed("ui_action"):
				mode = actowner.turnActMenu.get_current_action()
				print("mode:", mode)
				match mode:
					"info":
						actowner.infoDisplay.display_units(actowner.units, "alphared")
						state = STATE_INFO
					"end turn":
						endstate = true
						actowner.turnGroup = "alphablue"
						
			elif Input.is_action_just_pressed("ui_back"):
				actowner.turnActMenu.hide()
				actowner.cursor.canMove = true
				actowner.infoDisplay.hide()
				state = STATE_IDLE

		STATE_INFO:
			if Input.is_action_just_pressed("ui_back"):
				actowner.infoDisplay.close()
				state = STATE_ON_TURN_MENU

		STATE_IDLE:
			if Input.is_action_just_pressed("ui_action"):
				if actowner.select_hover_unit():
					actowner.display_unit_actions()

			elif Input.is_action_just_pressed("ui_accept"):
				actowner.turnActMenu.show()
				actowner.cursor.canMove = false
				state = STATE_ON_TURN_MENU
			
				
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
