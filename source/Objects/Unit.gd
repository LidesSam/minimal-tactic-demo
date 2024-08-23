extends Node2D

var playerID=0

@export var unitName = "name"
@onready var sprite=$spr

var gpos=Vector2(0,0)

var actions=["move","atk","wait"]
var actEnabled =[true,true,true]

var framesPath ="res://assets/Images/Units/"

var minAtkArea=1
var maxAtkArea=1
var atk=1
var def=1
var maxlp=10
var lp=10
var moves=3
var player="red"

var state="active"

var currentAction="none"
var fsm
# Called when the node enters the scene tree for the first time.
func _ready():	
	fsm= $fsm
	fsm.autoload(self)
	#fsm.addStateTransition("active","move",$fsm/active.state_ended)
	#fsm.addStateTransition("active","move",$fsm/active.state_ended)
	#fsm.addStateTransition("move","active",$fsm/turnstart.state_ended)
	#fsm.addStateTransition("inactive","active",$fsm/turnstart.state_ended)
	#fsm.addStateTransition("move","active",$fsm/turnstart.state_ended)
	
	fsm.startState()
	fsm.set_debug_on($debug)
		
	pass # Replace with function body.
	
func move_used():
	actEnabled[0]==false
	
func can_move():
	return actEnabled[0]
	
func atk_used():
	actEnabled[1]==false
	
func can_atack():
	return actEnabled[1]
			
func defineAs(NAME="soldier",_PLAYER="red"):
	player=_PLAYER
	print("pla:",_PLAYER)
	unitName=NAME
	var anim= str("soldier-idle-",_PLAYER)
	sprite=$spr
	lp=maxlp
	match unitName:
		"soldier":
			maxlp=3
			anim= str("soldier-idle-",_PLAYER)
		"spearman":
			maxlp=4
			anim= str("spearman-idle-",_PLAYER)
		"archer":
			maxlp=2
			minAtkArea=2
			maxAtkArea=3
			anim= str("archer-idle-",_PLAYER)
		"bandit":
			maxlp=2
			anim= str("bandit-idle-",_PLAYER)
		_:
			defineAs("soldier",_PLAYER)
			pass	
	lp=maxlp
	sprite.play(anim)
	update_lp()
	
func _process(delta):
	pass
func update_lp():
	$lp.text=str(lp,"/",maxlp)

func hurt(point=0):
	lp-=point
	if(lp<=0):
		lp=0
	update_lp()


func set_in_grid_position(_gpos = Vector2(0,0)):
	gpos=_gpos
	position = gpos*16
	pass
	
#enter in select state and wait for orders
func select():
	state="select"
	$spr
	$ColorRect.color="#005555";

func deselect():
	state="active"
	$ColorRect.color="#ffffff";
	
func inactive():
	state="inactive"
	$ColorRect.color="#ff0000";
	pass
	
func startTurn():
	actEnabled =[true,true,true]
	state="active"
	$ColorRect.color="#ffffff";

# uset to start move smoothly to the next grid
#for test this gonna put it right away, instead, the smooth move gona be made later
func moveTo(_gpos = Vector2(0,0)):
	$spr.position=Vector2(0,0)
	actEnabled[0]=false
	set_in_grid_position(_gpos)
	pass	

func move_spr_only(_gpos = Vector2(0,0)):
	$spr.global_position= _gpos*16

func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	get_parent().update_data_display(self)
	pass # Replace with function body.

func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	get_parent().update_data_display()
	get_parent().hover_unit(self)
	pass # Replace with function body.
	
func get_spr_texture():
	return $AnimatedSprite2D.frame

func get_unitName():
	return unitName
	
func get_move_range():
	return moves

func get_atk_range():
	return atk
