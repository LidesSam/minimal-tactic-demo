extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var onConfirm=false
var mode=""



func _ready():
	super()	

func enter(actowner):
	super(actowner)
	
	actowner.turnActMenu.show()
	actowner.cursor.canMove=false
	onConfirm=false

func update(actowner,delta):
	pass

func handleInput(actowner, event):
	if Input.is_action_just_pressed("ui_action"):
		mode = actowner.turnActMenu.get_current_action()
		print("mode:", mode)
		match mode:
			"info":
				actowner.infoDisplay.display_units(actowner.units, "alphared")
				actowner.state = actowner.STATE_INFO
			"end turn":
				actowner.state=actowner.STATE_IDLE
				endstate = true
				actowner.turnGroup = "alphablue"
			"surrender":
				pass
			"exit":
				get_tree().change_scene_to_file("res://source/Screens/MainMenu.tscn")
	elif Input.is_action_just_pressed("ui_back"):
		actowner.state=actowner.STATE_IDLE


func state_ended():
	return endstate
	
func exit(actowner):
	actowner.turnActMenu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
