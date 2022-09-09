extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!
#
#this class and code is
#unfinished and no implemente(Yet)
#
#WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!WARNIG!!!

var isGlobal=false
var condition = null
var currentState=null
var nexState=null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func defineAsGlobal(nstate,cond):
	isGlobal=true
	nexState=nstate
	condition=cond
	pass

func defineAs(cstate, nstate,cond):
	
	isGlobal=false
	currentState=	cstate
	nexState=nstate
	condition=cond
	pass



func checkCondition(cstate,fsm):
	if(isGlobal):
		print("here it goes global")
#		if(condition()):
#				fsm.changeState(nextState)
	else:
		if(currentState==cstate):
			print("here it goes")
#			if(condition()):
#				fsm.changeState(nextState)
		else:
			print("not match; next")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
