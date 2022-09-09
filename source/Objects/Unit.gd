extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerID=0

export var unitName = "name"
onready var sprite=$spr
var atk=1
var def=1
var maxlp=10
var lp=10
var moves=3
var gpos=Vector2(0,0)
var actions=["move","atk","wait"]
var actEnabled =[true,true,true]
var framesPath ="res://assets/Images/Units/"


var indirect = false

var minAtkArea=1
var maxAtkArea=1

var state="active"

var currentAction="none"

# Called when the node enters the scene tree for the first time.
func _ready():
	actions=["move","wait"]
	
	pass # Replace with function body.

func defineAs(NAME="soldier",owner="red"):
	unitName=NAME
	sprite=$spr
	match unitName:
		"soldier":
#			atk=10
#			def=10
#			maxlp=10
			lp=maxlp
			sprite.play("soldier-idle-red")
		"spearman":
			
			sprite.play("spearman-idle-red")
		"archer":
			
			sprite.play("archer-idle-red")
		"bandit":
			
			sprite.play("bandit-idle-red")
		_:
			defineAs("soldier",owner)
			pass
	
	
			
	
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_in_grid_position(_gpos = Vector2(0,0)):
	gpos=_gpos
	position = gpos*16
	pass
	
#enter in select state and wait for orders
func select():
	state="select"
	$ColorRect.color="#005555";

func unselect():
	
	state="active"
	$ColorRect.color="#ffffff";

func inactive():
	
	state="inactive"
	$ColorRect.color="#ff0000";
	pass
	
func startTurn():
	
	state="active"
	$ColorRect.color="#ffffff";

# uset to start move smoothly to the next grid
#for test this gonna put it right away, instead, the smooth move gona be made later
func moveTo(_gpos = Vector2(0,0)):
	set_in_grid_position(_gpos)
	pass	
	
func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	get_parent().updateDataDisplay(self)
	
	pass # Replace with function body.


func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	get_parent().updateDataDisplay()
	get_parent().hover_unit(self)
	pass # Replace with function body.
func get_spr_texture():
	return $AnimatedSprite.frame
func get_unitName():
	return unitName
