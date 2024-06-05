extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false

func enter(actowner):
	endstate=true
	
func state_ended():
	return endstate
