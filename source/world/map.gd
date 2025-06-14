extends Node2D

#grid related vars
var gridHover=[]
var enabledCell =[]
var enabledCellGridPos =[]

@onready var gridDim= Vector2(20,12)
@onready var gridHoverNode=$gridhover
@onready var tilemap =$tilemap

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
				if tilemap.get_cell_source_id(lcell)!=-1:
					
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
	
func position_is_enabledCell(pos= Vector2(0,0)):
	for cellPos in enabledCellGridPos:
		if(cellPos== pos):
				return true
	return false
	

func get_enabled_cell():
	return enabledCell;
