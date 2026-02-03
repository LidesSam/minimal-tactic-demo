extends Node2D

@onready var tempUnit = preload("res://source/Objects/Unit.tscn")
@onready var fsm = $fsm

var units=[]

var turnGroup="alphared"

var selectUnit=null
var hoverUnit=null
var targetUnit=null

var selectedUnitMode=0
static var UNIT_UNSELECTED=0 
static var UNIT_SELECTED=1 

#grid related vars
var gridHover=[]  #temp
@onready var gridDim= Vector2(20,12) #temp moved to map 

#var enabledCell =[]
#var enabledCellGridPos =[]

@onready var dataDisplay=$DataDisplay

@onready var infoDisplay=$infoDisplay
@onready var map =$map
@onready var tilemap =$map/tilemap
@onready var cursor =$map/cursor

#action menus
@onready var unitActMenu=$Cam/unitActions
@onready var turnActMenu=$Cam/turnActions
@onready var stateLbl = $stateLbl
@onready var turn=0
@onready var round=0

var state=""

const STATE_IDLE = ""
const STATE_ON_TURN_MENU = "onturnmenu"
const STATE_INFO = "info"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.world=self
	cursor.set_grid_pos()
	set_process_input(true)
	cursor.gridDim= gridDim
#	show_grid_area(Vector2(2,2),2);
	fsm.autoload(self)
	
	fsm.addStateTransition("turnstart","playerturn",$fsm/turnstart.state_ended)
	
	fsm.addStateTransition("playerturn","unitselected",unitIsSelected)
	
	fsm.addStateTransition("playerturn","turnMenuState",on_turn_menu)
	fsm.addStateTransition("turnMenuState","playerturn",out_turn_menu)
	
	fsm.addStateTransition("turnMenuState","infoGralScreen",on_info_menu)
	fsm.addStateTransition("infoGralScreen","turnMenuState",on_turn_menu)
	
	fsm.addStateTransition("unitselected","playerturn",$fsm/unitselected.state_ended)
	fsm.addStateTransition("turnMenuState","foeturn",foeturn)
	fsm.addStateTransition("foeturn","turnstart",$fsm/foeturn.state_ended)
	
	$fsm/unitselected.exitaction=free_unit_selector;
	fsm.startState()
	fsm.set_debug_on($stateLbl)
	
	map.generate_overlay_grid()
	#map bypasss function
	#temporaty set for a progresive componentization of this code.
	#eventually this only gonna contain
	#*definition of vars
	#*fsm requeriments
	#*fsm vars
	#inputs
	gridHover=map.gridHover  #temp
	gridDim= map.gridDim #temp moved to map 
	tilemap =map.tilemap
	
	test()
	day_end()

func foeturn():
	return turnGroup!="alphared"

func on_turn_menu():
	return state == STATE_ON_TURN_MENU
	
func out_turn_menu():
	return state == STATE_IDLE
	
	
func on_info_menu():
	return state == STATE_INFO
	
func day_end():
	round+=1
	$Cam/turn.text=str("day:",round)

func free_unit_selector():
	selectedUnitMode== UNIT_UNSELECTED
	
func unitIsSelected():
	return selectedUnitMode== UNIT_SELECTED

#create a few unit to test
func test():
	for i in range(3):
		print("creatinf pla unit red:",i)
		var unit = tempUnit.instantiate()
		unit.set_in_grid_position(Vector2(1+i*2,2))
		unit.add_to_group("alphared")
		match(i):
			0:
				unit.defineAs("swordman")
			1:
				unit.defineAs("spearman")
			2:
				unit.defineAs("archer")
			_:
				unit.defineAs("swordman")
		
		$map/units.add_child(unit)
		units.push_back(unit)
	
	for i in range(3):
		print("creatinf pla unit blue:",i)
		var unit = tempUnit.instantiate()
		unit.set_in_grid_position(Vector2(5+i*2,2+5))
		unit.add_to_group("alphablue")
		$map/units.add_child(unit)
		units.push_back(unit)
		match(i):
			0:
				unit.defineAs("swordman","blue")
			1:
				unit.defineAs("spearman","blue")
			2:
				unit.defineAs("archer","blue")
			_:
				unit.defineAs("swordman","blue")
	pass


			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fsm.fsmUpdate(delta)
	#reset_hover_unit()
	pass
	
func select_hover_unit():
	if(hoverUnit!=null):
		if(hoverUnit.state!="inactive" && !hoverUnit.is_foe()):
			selectUnit=hoverUnit
			selectedUnitMode=UNIT_SELECTED
			hoverUnit.select()
			return true
	return false
		
func _input(event):
	fsm.handleInput(event)

func check_and_remove_dead_unit(u):
	if u.lp <= 0:
		units.erase(u)  # Removes u from the array safely
		if u.get_parent():  # Ensure u has a parent before removing it
			u.get_parent().remove_child(u)

	
func remove_dead_units():
	for u in units:
		check_and_remove_dead_unit(u)
	pass

func activate_all_units(team="blue"):
	for unit in $map/units.get_children():
		if(unit.player==team):
			unit.start_turn()
func get_disable_active_unit(team="blue"):
	for unit in $map/units.get_children():
		if(unit.player==team && unit.is_active()):
			unit.inactive()
			return true
	return false


func reset_hover_unit():
	if Input.is_action_just_pressed("ui_right"):
		hover_unit(null)
	else:
		if Input.is_action_just_pressed("ui_left"):
			hover_unit(null)
		else:
			if Input.is_action_just_pressed("ui_up"):
				hover_unit(null)
			else:
				if Input.is_action_just_pressed("ui_down"):
						hover_unit(null)

func hover_unit(unit):
	if(selectedUnitMode==0):
		hoverUnit=unit
		if(hoverUnit==null):
			$Label.text="hover:none"
		else:
			$Label.text=str("hover:",hoverUnit.unitName)
		dataDisplay.update_data_display(hoverUnit)
	else:
		target_unit(unit)		
	pass

func target_unit(unit):
	targetUnit=unit
	if(targetUnit==null):
		$tunitlbl.text="tunit:none"
	else:
		$tunitlbl.text=str("hover:",hoverUnit.unitName)
		print("please target:",targetUnit.get_unitName())
	dataDisplay.update_data_display(hoverUnit)


func check_cursor_hover_unit(gridPos):
	var find_unit= false
	for u in units:
		if(u.gpos==gridPos):
			hoverUnit=u
			find_unit = true
	if(!find_unit):
		hoverUnit=null
	
func dissable_grid():
	map.dissable_grid()
	cursor.onRestrictedMode = false

func show_unit_moves():
	if(hoverUnit!=null):
		map.show_grid_area(hoverUnit.gpos,0,hoverUnit.moves,Color.BLUE) 
		cursor.onRestrictedMode = true

func show_unit_atk():
	if(hoverUnit!=null):
		map.show_grid_area(hoverUnit.gpos,hoverUnit.minAtkArea,hoverUnit.maxAtkArea,Color.RED) 
		for u in units:
			if u.player!="red":
				var target = u.in_act_range(map.enabledCellGridPos)
				if(target):
					$fsm/unitselected.targeteableUnits.push_back(u)
				
		
		cursor.onRestrictedMode = true
func release_atk_select():
	for u in units:
			if u.player!="red":
				u.out_target()
	


func move_unit_to_cursor_pos():
	if(targetUnit==null):
		selectUnit.moveTo(cursor.get_grid_pos())
#		-> move to after confirmation of move
		dissable_grid()
		$ok_sound.play()
		print("aloha")
		selectUnit.move_used()
		return true
	else:
		$back_sound.play()
		return false

func move_shadow_to_pos():
	if(targetUnit==null):
		hoverUnit.move_spr_only(cursor.get_grid_pos())
#		-> move to after confirmation of move
		#dissable_grid()
		$ok_sound.play()
		return true
	else:
		$back_sound.play()
		return false
	
#shortcut funtion to UnitAction menu
func display_unit_actions(moveAct=true):
	cursor.canMove=false
	unitActMenu.show()
	unitActMenu.set_actions_from_units(hoverUnit)

func hide_unit_actions():
	cursor.canMove=true
	unitActMenu.hide()

#shortcut funtion to UnitAction menu	
func display_turn_actions(moveAct=true):
	cursor.canMove=false
	turnActMenu.show()
	
func hide_turn_actions(moveAct=true):
	cursor.canMove=true
	turnActMenu.hide()

func inactiveUnit():
	hoverUnit.inactive()
	hoverUnit=null					
