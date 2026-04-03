extends Control

@onready var tilemap:TileMapLayer = $world/TileMap
@onready var mainMenu=$CanvasLayer/options/Main
@onready var placingMenu=$CanvasLayer/options/Placing 
@onready var fillMenu=$CanvasLayer/options/Fill

@onready var cursor= $cursor
@onready var fsm= $fsm

enum MENU {MAIN, PLACINGSELECTION, FILLER,TILES, UNITS}
enum ACTIONS {PLACE, ERASE, PICK, INPECT}

var currentMenu=0

func _ready():
	new_map()
	Global.world=self
	fsm.autoload(self)
	fsm.addGlobalTransition("mainMenu",on_main_menu)
	fsm.addStateTransition("mainMenu","fillerSelection",on_fill_selection)
	
	fsm.startState()
	cursor.mode=cursor.EDITORMODE
	cursor.move=false
	
func  on_main_menu():
	return currentMenu==MENU.MAIN
	
func  on_fill_selection():
	return currentMenu==MENU.FILLER
	
func exit_editor():
	get_tree().change_scene_to_file("res://source/Screens/MainMenu.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fsm.fsmUpdate(delta)
	
func _input(event: InputEvent) -> void:
	fsm.handleInput(event)
	
func save_map():
	pass

func fill_map(TerrainType:String="field"):
	print("filling:")
	
	print("filling:",tilemap.tile_map_data)
	for x in range(16):
		for y in range(12):
			
			print("filling:",tilemap.tile_map_data)
			match (TerrainType):
				"field":
					tilemap.set_cell(Vector2i(x,y),0,Vector2i(2, 2),randi()%3)
					pass
				"rock":
					tilemap.set_cell(Vector2i(x,y),0,Vector2i(0, 3))
					pass
				"ocean":
					tilemap.set_cell(Vector2i(x,y),0,Vector2i(2, 3))
					pass
				"mountain":
					tilemap.set_cell(Vector2i(x,y),0,Vector2i(3, 3))
					pass
				"forest":
					tilemap.set_cell(Vector2i(x,y),0,Vector2i(3, 3))
					pass
			pass
			
func new_map():
	fill_map()
