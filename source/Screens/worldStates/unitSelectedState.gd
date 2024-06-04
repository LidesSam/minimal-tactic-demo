extends "res://addons/fsmgear/source/FsmState.gd"

var endstate=false
var onConfirm=false
var mode= ""
# Called when the node enters the scene tree for the first time.
func _ready():
	mode= ""
	super()
	pass # Replace with function body.

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
					pass
		else:
			mode = actowner.unitActMenu.get_current_action()
			match(mode):
				"move":
					actowner.show_unit_moves()
					onConfirm=true
					actowner.cursor.canMove=true
				"atk":
					actowner.show_unit_atk()
					onConfirm=true
				"wait":
					actowner.hoverUnit.inactive()
					unselect(actowner)
			
	if Input.is_action_just_pressed("ui_back"):
		if(onConfirm):
			actowner.dissable_grid()
			onConfirm=false
			actowner.display_unit_actions()
		else:
			unselect(actowner)

func unselect(actowner):
	actowner.selectedUnitMode= actowner.UNIT_UNSELECTED
	actowner.hover_unit(null)
	endstate=true

func state_ended():
	return endstate
func exit(actowner):
	super(actowner)
	actowner.hide_unit_actions()
