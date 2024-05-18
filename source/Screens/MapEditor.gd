extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var tilemap
# Called when the node enters the scene tree for the first time.
func _ready():
	new_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func save_map():
	pass

func fill_map():
	for x in range(16):
		for y in range(12):
			
			$world/TileMap.set_cell(0,Vector2i(x,y),1,)
	pass
func new_map():
	fill_map()
