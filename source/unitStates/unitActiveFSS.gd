extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false

func enter(actowner):
	super(actowner)
	endstate=true
	actowner.startTurn()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func state_ended():
	return endstate
