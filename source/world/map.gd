extends Node2D

#grid related vars
var gridHover=[]

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
