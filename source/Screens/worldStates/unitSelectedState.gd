extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var onConfirm=false
var mode= ""
var targeteableUnits=[]
var targetIdx=0
# Called when the node enters the scene tree for the first time.
func _ready():
	mode= ""
	super()

func enter(actowner):
	endstate=false
	onConfirm=false
	super(actowner)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handleInput(actowner,event):
	if Input.is_action_just_pressed("ui_action"):
		if(onConfirm):
			match(mode):
				"move":
					actowner.move_unit_to_cursor_pos()
					unselect(actowner)
					pass
					
				"atk":
					if(targeteableUnits.size()>0):
						if(targeteableUnits[targetIdx]!=null):
							targeteableUnits[targetIdx].hurt(actowner.selectzxUnit.atk)
							actowner.check_and_remove_dead_unit(targeteableUnits[targetIdx])
							actowner.selectUnit.inactive()
							unselect(actowner)
							actowner.dissable_grid()
					pass
		else:
			mode = actowner.unitActMenu.get_current_action()
			match(mode):
				"move":
					actowner.show_unit_moves()
					onConfirm=true
					actowner.cursor.canMove=true
				"atk":
					targeteableUnits=[]
					actowner.show_unit_atk()
					onConfirm=true
					targetIdx=0
					if targeteableUnits.size() > 0:  
						actowner.get_node("cursor").move_to_cell(targeteableUnits[targetIdx].gpos)
				
				"wait":
					actowner.selectUnit.inactive()
					unselect(actowner)
			
	if Input.is_action_just_pressed("ui_back"):
		if(onConfirm):
			match(mode):
				"move":
					pass
				"atk":
					targeteableUnits=[]
					actowner.release_atk_select()
					
			
			actowner.dissable_grid()
			actowner.display_unit_actions()
			onConfirm=false
		else:
			unselect(actowner)
			
	if mode=="atk":
		pass

func unselect(actowner):
	actowner.selectedUnitMode= actowner.UNIT_UNSELECTED
	actowner.hover_unit(null)
	endstate=true

func state_ended():
	return endstate
	
func exit(actowner):
	super(actowner)
	actowner.hide_unit_actions()
