extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var actowner

var states = []
var statesNames = []

var globalToStates= []
var globalContiditions= []
var currentState=null
var currentStateAsignedName=""



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_owner(Owner):
	actowner=Owner
	pass


func clearStates():
	states = []
	statesNames = []
	currentState=null
	
# add a transition that don't consider the current state only a condition
func addGlobalTransition(stateName,funcName ):
	globalToStates.push_back(stateName)
	var condRef = funcref(actowner,funcName)
	
	globalContiditions.push_back(condRef)
	
# add states
func addState(state_name, statePath):
#	need to add a sech for duplicates
#	or a function "find_state()"
#	------------->here<-----------



#	 ------------->here<-----------
#	add estate and name of it	
	statesNames.push_back(state_name)
#	create state and past this as parent
	var st=load(statePath).new()
	st.setFsmParent(self)
#push state
	states.push_back(st)

	
func setStates():
	print("setStates")
	loadDefStates()

# used for test in the project "Snow Mania"
func loadDefStates():
	addState("idle", "res://src/objects/PlayerStates/idleState.gd")
	addState("jump", "res://src/objects/PlayerStates/jumpState.gd")
	addState("fall", "res://src/objects/PlayerStates/fallState.gd")
	

	
	pass
	
#start the first State
func startState():
	currentStateAsignedName=statesNames[0]
	currentState = states[0]
	currentState.enter(actowner)

func getCurrentStateName():
	return currentStateAsignedName
func fsmUpdate(delta):
	
	
	currentState.update(actowner,delta)
#	test code fragment1
	for i in range(globalContiditions.size()):
		if(globalContiditions[i].call_func()):
#			print("global nº",i," triggered")
			change_to_state(globalToStates[i])
##	test code fragment 2
#	if (currentState.StateName!="idle" and actowner.isGrounded):
#		print("1")
#		change_to_state("idle")
#	test code fragment end
#	pass
func handleInput():
	currentState.handleInput(actowner)

func change_state(nextState):
	
	currentState.exit(actowner)
	currentState= nextState
	currentState.enter(actowner)
	pass
	
func change_state_by_index(idx):
	change_state(states[idx])
#	print("change_state")
	
func change_to_state(state_name):
	 
	var idx =0
	for st in statesNames:
		if st == state_name:
			currentStateAsignedName=state_name
			change_state_by_index(idx)
		idx+=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
