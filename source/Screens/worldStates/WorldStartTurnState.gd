extends "res://source/Fsm/FsmState.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func enter(actowner):
	.enter(actowner)
	
	
	actowner.selectUnitMode=0
	actowner.start_turn()
#	actowner.cursor.move=true
	pass
	

func update(actowner,delta):
	parentFsm.change_to_state("nav")
	pass

