extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gridPos=Vector2(0,0)
var gsize=16

var gridDim=Vector2(1,1)
#controled by a timer slow down grid movement
var move=false

#system outside look to "lock the cursor in a position"
#when other object need it 
var canMove=true
var onRestrictedMode=false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_Grid_Pos()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#
func _process(delta):
	if(move and canMove):
			
		if Input.is_action_pressed("ui_right"):
			move_to_cell(gridPos+Vector2(1,0))
		if Input.is_action_pressed("ui_left"):
			move_to_cell(gridPos+Vector2(-1,0))
		if Input.is_action_pressed("ui_up"):
			move_to_cell(gridPos+Vector2(0,-1))
		if Input.is_action_pressed("ui_down"):
			move_to_cell(gridPos+Vector2(0,1))
			
#	pass
func move_to_cell(cell=Vector2(0,0)):
	if(onRestrictedMode):
		if(get_parent().position_is_enabledCell(cell)):
			gridPos=cell
			set_Grid_Pos()
	
	else:
		gridPos=cell
		set_Grid_Pos()
	
func set_Grid_Pos():
#	if the position(xory) is out of the map correct to th min or max value
	if(gridPos.x<0): gridPos.x=0
	if(gridPos.y<0): gridPos.y=0
	if(gridPos.x>=gridDim.x): gridPos.x=gridDim.x-1
	if(gridPos.y>=gridDim.y): gridPos.y=gridDim.y-1
	
	print(position)
	position = gridPos*gsize
	$Timer.start()
	move=false
	get_parent().update_data_display()

func get_Grid_Pos():
	return gridPos
	
func _on_Timer_timeout():
	move=true
	pass # Replace with function body.
