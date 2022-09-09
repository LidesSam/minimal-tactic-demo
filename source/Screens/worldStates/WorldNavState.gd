extends "res://source/Fsm/FsmState.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mode= "freeNav"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func enter(actowner):
	.enter(actowner)
	mode= "freeNav"
	actowner.selectUnitMode=0
	
#	actowner.cursor.move=true
	pass
	

func update(actowner,delta):
	match mode:
		"freeNav":
			if(actowner.hoverUnit!=null):
				if(Input.is_action_just_pressed("ui_action")):
					print(actowner.hoverUnit.state)
					if(actowner.hoverUnit.state=="active"):
						actowner.hoverUnit.select()
			#			actowner.showUnitMoves()
						parentFsm.change_to_state("selectedUnit")
			if(Input.is_action_just_pressed("ui_accept")):
				actowner.displayTurnActions()
				mode="mainMenu"
				print("mainMenu")
		"mainMenu":
			mainMenu(actowner)
		
	pass

func mainMenu(actowner):
	if(Input.is_action_just_pressed("ui_back") or Input.is_action_just_pressed("ui_accept")):
		actowner.hideTurnActions()
		mode="freeNav"
	if(Input.is_action_just_pressed("ui_action")):
		print("aloha")
		if(actowner.turnActionChose()=="end turn"):	
				actowner.hideTurnActions()
				parentFsm.change_to_state("start-turn")
				print("restartTurn")
					
