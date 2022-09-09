extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var turn=0

onready var tempUnit = preload("res://source/Objects/Unit.tscn")
onready var fsm = preload("res://source/Fsm/Fsm.gd").new()

var units=[]
var turnGroup="alphared"


var hoverUnit=null
var targetUnit=null
var selectUnitMode=0

var gridHover=[]

onready var gridDim= Vector2(20,12)
onready var gridHoverNode=$gridhover

var enabledCell =[]
var enabledCellGridPos =[]

onready var cursor =$cursor

#action menus
onready var unitActMenu=$unitActions
onready var turnActMenu=$turnActions
onready var stateLbl = $stateLbl
# Called when the node enters the scene tree for the first time.
func _ready():
	cursor.gridDim= gridDim
	

	
	for gx in range(gridDim.x):
		gridHover.append([])
		gridHover[gx]=[]
	
		for gy in range(gridDim.y):
			
			var gh = ColorRect.new()
			gh.rect_size=Vector2(16,16)
			gh.rect_position=Vector2(gx,gy)*16
			gh.color="#55000055"
			gh.hide()
			
			gridHover[gx].append(gh)  
			gridHover[gx][gy]=gh
			gridHoverNode.add_child(gh)

	
	
#	showGridArea(Vector2(2,2),2);
	
	test()
	fsm.set_owner(self)
	fsm.addState("start-turn","res://source/Screens/worldStates/WorldStartTurnState.gd")
	fsm.addState("nav","res://source/Screens/worldStates/WorldNavState.gd")
	fsm.addState("selectedUnit","res://source/Screens/worldStates/WorldUnitSelectState.gd")
	
	fsm.startState()
	
	pass # Replace with function body.


#create a few unit to test
func test():
	
	for i in range(3):
		var unit = tempUnit.instance()
		unit.defineAs("swordman")
		if(i==1):
			unit.defineAs("spearman")
		
		unit.set_in_grid_position(Vector2(1+i*2,2))
		unit.add_to_group("alphared")
		add_child(unit)
		units.push_back(unit)
	pass


func updateDataDisplay():
#	print(unit.get_unitName())
	$DataDisplay.show()
#	$DataDisplay/Sprite.texture = unit.get_spr_texture()
	if(hoverUnit==null):
		$DataDisplay/Label.text=""
	else:
		$DataDisplay/Label.text= hoverUnit.get_unitName()
	
func resetDataDisplay():
	$DataDisplay.hide()
	
	
func start_turn():
	print("startturn:",turnGroup)
	stateLbl.text="state:start"
	for u in units:
		if(u.is_in_group(turnGroup)):
			u.startTurn()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if(Input.is_action_just_pressed("ui_back")):
#		dissableGrid()
#		pass
	
	fsm.fsmUpdate(delta)
	resetHoverUnit()
	pass
	
	
func selectHoverUnit():
		if(hoverUnit!=null):
			selectUnitMode=1
			hoverUnit.select()
	
func resetHoverUnit():
	
	
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
	if(selectUnitMode==0):

		hoverUnit=unit
		if(hoverUnit==null):
			$Label.text="hover:none"
			print("please: none")
		else:
			$Label.text=str("hover:",hoverUnit.unitName)
			print("please:",hoverUnit.get_unitName())
		updateDataDisplay()
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
	updateDataDisplay()	
	pass	

# unoptimized algoritm
func showGridArea(origin,size,color="#55000055"):

#	dfs
	print(size)
	enabledCell =[]
	var lastSeach =[]
	var cgrid=gridHover[origin.x][origin.y]
	gridHover[origin.x][origin.y].show()
	lastSeach.push_back(origin)
	for i in range(size):
		var nLastSeach=[]
		for pos in lastSeach:
			print(lastSeach)
		
			for lcell in get_limit_cell(pos):
				nLastSeach.push_back(lcell)
				enabledCell.push_back(gridHover[lcell.x][lcell.y])
				enabledCellGridPos.push_back(Vector2(lcell.x,lcell.y))
				gridHover[lcell.x][lcell.y].show()
				gridHover[lcell.x][lcell.y].color=color
				lastSeach=nLastSeach
		pass


func get_limit_cell(origin=Vector2(0,0)):
	var lcell =[]

	if(origin.x-1>=0):
		lcell.push_back(Vector2(origin.x-1,origin.y))
	
	if(origin.x+1<=gridDim.x):
		lcell.push_back(Vector2(origin.x+1,origin.y))
	
	if(origin.y-1>=0):
		lcell.push_back(Vector2(origin.x,origin.y-1))
	
	if(origin.y+1<=self.gridDim.x):
		lcell.push_back(Vector2(origin.x,origin.y+1))
	return lcell
	
func dissableGrid():

	for grid in enabledCell:
		grid.hide()
	enabledCell =[]
	enabledCellGridPos =[]
#	hoverUnit=null
	cursor.onRestrictedMode = false
	
func showUnitMoves():
	if(hoverUnit!=null):
		showGridArea(hoverUnit.gpos,hoverUnit.moves,"#55000055") 
		cursor.onRestrictedMode = true
	
func showUnitAtk():
	if(hoverUnit!=null):
		showGridArea(hoverUnit.gpos,hoverUnit.moves,"#55550000") 
		cursor.onRestrictedMode = true
#		

func showGridSquare(origin,size):
	pass
	
func position_is_enabledCell(pos= Vector2(0,0)):
	
	for cellPos in enabledCellGridPos:

		if(cellPos== pos):
				return true
		
	
	return false
#
func moveUnitToCursorPos():
	if(targetUnit==null):

		hoverUnit.moveTo(cursor.get_Grid_Pos())
#		-> move to after confirmation of move
		dissableGrid()
		$ok_sound.play()
#		->
		return true
	else:
		$back_sound.play()
		return false
		
#shortcut funtion to UnitAction menu
func displayUnitActions(moveAct=true):
	cursor.canMove=false
	unitActMenu.show()

func hideUnitActions():
	
	cursor.canMove=true
	unitActMenu.hide()
	
func actionChose():
	return unitActMenu.get_current_action()

#shortcut funtion to UnitAction menu	
func displayTurnActions(moveAct=true):
	cursor.canMove=false
	turnActMenu.show()
	
func hideTurnActions(moveAct=true):
	cursor.canMove=true
	turnActMenu.hide()

func turnActionChose():
	return turnActMenu.get_current_action()
	

func inactiveUnit():
	hoverUnit.inactive()
	hoverUnit=null					
	

func get_enabled_cell():
	return enabledCell;

func turnEnd():
	pass
