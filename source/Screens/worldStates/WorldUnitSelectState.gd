extends "res://source/Fsm/FsmState.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var phase="unitFirstAct" 
var firstAct=false



#"unitFirstAct" "Moving" "unitSecondAct" "Wait-Unit-Result"] 
#moving is the only action that can be follow for another
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter(actowner):
	.enter(actowner)
	firstAct=false
	actowner.displayUnitActions()
	phase="unitFirstAct" 
	actowner.selectUnitMode=1
	
#	actowner.cursor.move=false
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(actowner,delta):
	if(Input.is_action_just_pressed("ui_action")):
#		test action reduced for lack of animations
		match(phase):
			"unitFirstAct":
				unitActions(actowner)
					
			"choseNextPos":
				if(actowner.moveUnitToCursorPos()):
#					real
					phase = "unitPreSecondAct"
#					for test
#					actowner.targetUnit=null
					
#					phase="end"
					
			
			"choseAtkPoss":
				print("atk")
#				parentFsm.change_to_state("nav")
#				if(actowner.moveUnitToCursorPos()):
#					phase = "unitAtk"
#					actowner.unitAtk()
#					actowner.displayUnitActions()
				phase="end"
				pass
			"unitAtk":
#				if(actowner.atkEnd):
				
				
			
				pass
			"unitPreSecondAct":
				print("unit second act")
				phase="unitSecondAct"
				actowner.displayUnitActions()
			"unitSecondAct":
				unitActions(actowner)
			"end":
				print("jola")
				actowner.selectUnitMode=0
				parentFsm.change_to_state("nav")
				
			
			
			
	if(Input.is_action_just_pressed("ui_back")):
			parentFsm.change_to_state("navMode")
	pass
	
func unitActions(actowner):
	
	
	
	if(actowner.actionChose()=="move"):
			phase = "choseNextPos"
			actowner.showUnitMoves()
			actowner.hideUnitActions()
			actowner.cursor.move=true
					
	if(actowner.actionChose()=="atk"):
		phase = "choseAtkPos"
		actowner.showUnitAtk()
		actowner.hideUnitActions()
		actowner.cursor.move=true	
					
	if(actowner.actionChose()=="wait"):
		phase = "end"
		actowner.inactiveUnit()
		actowner.hideUnitActions()
		actowner.cursor.move=true
func exit(actowner):
	.exit(actowner)
	actowner.selectUnitMode=0
	
