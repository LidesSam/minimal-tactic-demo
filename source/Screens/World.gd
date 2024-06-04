extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turn=0

@onready var tempUnit = preload("res://source/Objects/Unit.tscn")
@onready var fsm = $fsm

var units=[]
var turnGroup="alphared"

var hoverUnit=null
var targetUnit=null

var selectedUnitMode=0
static var UNIT_UNSELECTED=0 
static var UNIT_SELECTED=1 

var gridHover=[]

@onready var gridDim= Vector2(20,12)
@onready var gridHoverNode=$gridhover

var enabledCell =[]
var enabledCellGridPos =[]

@onready var cursor =$cursor

#action menus
@onready var unitActMenu=$Cam/unitActions
@onready var turnActMenu=$Cam/turnActions
@onready var stateLbl = $stateLbl
@onready var round=0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	cursor.gridDim= gridDim
#	show_grid_area(Vector2(2,2),2);
	test()
	fsm.autoload(self)
	
	fsm.addStateTransition("turnstart","playerturn",$fsm/turnstart.state_ended)
	
	fsm.addStateTransition("playerturn","unitselected",unitIsSelected)
	fsm.addStateTransition("unitselected","playerturn",$fsm/unitselected.state_ended)
	$fsm/unitselected.exitaction=free_unit_selector;
	fsm.startState()
	fsm.set_debug_on($stateLbl)
	
	generate_overlay_grid()
	day_end()
	
func day_end():
	round+=1
	$Cam/turn.text=str("day:",round)
func free_unit_selector():
	selectedUnitMode== UNIT_UNSELECTED
func unitIsSelected():
	return selectedUnitMode== UNIT_SELECTED
	
func generate_overlay_grid():
	gridHover=[]
	for gx in range(gridDim.x):
		gridHover.append([])
		gridHover[gx]=[]
		for gy in range(gridDim.y):
			var gh = ColorRect.new()
			gh.size=Vector2(16,16)
			gh.position=Vector2(gx,gy)*16
			gh.color="#55000055"
			gh.hide()
			gridHover[gx].append(gh)  
			gridHover[gx][gy]=gh
			gridHoverNode.add_child(gh)
	print("gridHover")
	print(gridHover)

#create a few unit to test
func test():
	for i in range(3):
		var unit = tempUnit.instantiate()
		unit.defineAs("swordman")
		if(i==1):
			unit.defineAs("spearman")
		if(i==2):
			unit.defineAs("archer")
		unit.set_in_grid_position(Vector2(1+i*2,2))
		unit.add_to_group("alphared")
		add_child(unit)
		units.push_back(unit)
		
	for i in range(3):
		var unit = tempUnit.instantiate()
		unit.defineAs("spearman","blue")
		if(i==1):
			unit.defineAs("swordman","blue")
		if(i==2):
			unit.defineAs("archer","blue")
		unit.set_in_grid_position(Vector2(5+i*2,2+5))
		unit.add_to_group("alphablue")
		add_child(unit)
		units.push_back(unit)
	pass


#move to a new clas data display
func update_data_display():
#	print(unit.get_unitName())
	$DataDisplay.show()
#	$DataDisplay/Sprite.texture = unit.get_spr_texture()
	if(hoverUnit==null):
		$DataDisplay/tunit/data/namelbl.text= ""
		$DataDisplay/tunit/data/movelbl.text= ""
		$DataDisplay/tunit/data/atklbl.text= ""
	else:
		$DataDisplay/tunit/data/namelbl.text= str("Name: " ,hoverUnit.get_unitName())
		$DataDisplay/tunit/data/movelbl.text= str("Moves",hoverUnit.get_move_range())
		$DataDisplay/tunit/data/atklbl.text= str("Atk:",hoverUnit.get_atk_range())
	
func resetDataDisplay():
	$DataDisplay.hide()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fsm.fsmUpdate(delta)
	#reset_hover_unit()
	pass
	
	
func select_hover_unit():
	if(hoverUnit!=null):
		selectedUnitMode=UNIT_SELECTED
		hoverUnit.select()
		return true
	return false
		
func _input(event):
	fsm.handleInput(event)

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
			print("please: none")
		else:
			$Label.text=str("hover:",hoverUnit.unitName)
			print("please:",hoverUnit.get_unitName())
		update_data_display()
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
	update_data_display()	
	pass	

# unoptimized algoritm
func show_grid_area(origin:Vector2i, skip ,size,color="#55000055",):
	enabledCell =[]
	var lastSeach =[]
	var cgrid=gridHover[origin.x][origin.y]
	gridHover[origin.x][origin.y].show()
	lastSeach.push_back(origin)
	
	print("show_grid_area origin:",origin," size:",size)
	
	for i in range(size):
		var nLastSeach=[]
		for pos in lastSeach:
			# get around tiles
			for lcell in get_limit_cell(pos):
				if $TileMap.get_cell_source_id(0,lcell,false)!=-1:
					
					var skipable=abs(lcell.x-origin.x)+abs(lcell.y-origin.y)
			
					if(skipable>=skip):
						enabledCell.push_back(gridHover[lcell.x][lcell.y])
						enabledCellGridPos.push_back(Vector2(lcell.x,lcell.y))
						gridHover[lcell.x][lcell.y].show()
						gridHover[lcell.x][lcell.y].color=color
					nLastSeach.push_back(lcell)
					lastSeach=nLastSeach

func get_limit_cell(origin=Vector2(0,0)):
	var lcell =[]

	if(origin.x-1>=0):
		lcell.push_back(Vector2i(origin.x-1,origin.y))
	
	if(origin.x+1<=gridDim.x):
		lcell.push_back(Vector2i(origin.x+1,origin.y))
	
	if(origin.y-1>=0):
		lcell.push_back(Vector2i(origin.x,origin.y-1))
	
	if(origin.y+1<=self.gridDim.x):
		lcell.push_back(Vector2i(origin.x,origin.y+1))
		
	return lcell
	
func dissable_grid():
	for grid in enabledCell:
		grid.hide()
	enabledCell =[]
	enabledCellGridPos =[]
#	hoverUnit=null
	cursor.onRestrictedMode = false

func show_unit_moves():
	if(hoverUnit!=null):
		show_grid_area(hoverUnit.gpos,0,hoverUnit.moves,Color.BLUE) 
		cursor.onRestrictedMode = true

func show_unit_atk():
	if(hoverUnit!=null):
		show_grid_area(hoverUnit.gpos,hoverUnit.minAtkArea,hoverUnit.maxAtkArea,Color.RED) 
		cursor.onRestrictedMode = true

func position_is_enabledCell(pos= Vector2(0,0)):
	for cellPos in enabledCellGridPos:
		if(cellPos== pos):
				return true
	return false

func move_unit_to_cursor_pos():
	if(targetUnit==null):
		hoverUnit.moveTo(cursor.get_Grid_Pos())
#		-> move to after confirmation of move
		dissable_grid()
		$ok_sound.play()
		print("aloha")
		hoverUnit.move_used()
#		->
		return true
	else:
		$back_sound.play()
		return false

func move_shadow_to_pos():
	if(targetUnit==null):
		hoverUnit.move_spr_only(cursor.get_Grid_Pos())
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

func get_enabled_cell():
	return enabledCell;

func turnEnd():
	pass
