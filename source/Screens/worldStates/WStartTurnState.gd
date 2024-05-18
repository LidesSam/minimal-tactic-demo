extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var units=null
func _ready():
	super()
	
	pass

func enter(actowner):
	
	actowner.stateLbl.text="state:start"
	units= actowner.units
	for u in units:
		if(u.is_in_group(actowner.turnGroup)):
			u.startTurn()
	endstate= true
	pass

func update(actowner,delta):
	
	pass

func handleInput(actowner,event):
	pass

func state_ended():
	return endstate
func exit(actowner):
	endstate= false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
