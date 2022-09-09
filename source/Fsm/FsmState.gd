extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# parent class to all fsm States
#func _ready():
#	pass # Replace with function body.
var StateName = null
var parentFsm = null



func setFsmParent(fsm):
	parentFsm=fsm

func enter(actowner):
	UpdateOwnerStateDisplay(actowner)
	print("enterState:",StateName)
	pass




func update(actowner,delta):
	pass

func handleInput(actowner):
	pass

func exit(actowner):
	
	print("exitState:",StateName)
	pass



func UpdateOwnerStateDisplay(actowner):
	if actowner.has_method("updateStateName"):
		actowner.updateStateName(StateName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
