extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tilemap = null
var world = null

var lastGridPosition = Vector2(0,0)
var gridPosition = Vector2(0,0)
var onMove=false

var pControl=true
var velocity = Vector2(0,0)
var dir="none"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_parent().visible):
		if(pControl==true):
			
			if(onMove):
				position +=velocity*100*delta
				var tx=gridPosition.x * 64 +32
				var ty=gridPosition.y * 64 +32
				match dir:
					"right":
						if(position.x>tx):
							#print("px",position.x," tx",tx)
							setInGridPosition()
					
					"left":
						if(position.x<tx):
							#print("px",position.x," tx",tx)
							setInGridPosition()
						pass
						#setInGridPosition()
					"up":
						if(position.y<ty):
							#print("py",position.y," ty",ty)
							setInGridPosition()
						pass
						#setInGridPosition()	
						
					"down":
						if(position.y>ty):
							#print("py",position.y," ty",ty)
							setInGridPosition()
						pass
					_:
						setInGridPosition()
			else:
				goToCell()
		
		

func goToCell():
	if(tilemap!=null):
			#setInGridPosition()
			if Input.is_action_pressed("ui_right"):
				if tilemap.get_cell(gridPosition.x+1,gridPosition.y)== 1:
					lastGridPosition=gridPosition
					gridPosition.x+=1
					velocity = Vector2(1,0)
					onMove=true
					dir="right"
					
					#setInGridPosition()	
			
			if Input.is_action_pressed("ui_left"):
				if tilemap.get_cell(gridPosition.x-1,gridPosition.y)== 1:
					lastGridPosition=gridPosition
					gridPosition.x-=1
					velocity = Vector2(-1,0)
					onMove=true
					dir="left"
					#setInGridPosition()
						
			if Input.is_action_pressed("ui_up"):
				if tilemap.get_cell(gridPosition.x,gridPosition.y-1)== 1:
					lastGridPosition=gridPosition
					gridPosition.y-=1
					velocity = Vector2(0,-1)
					onMove=true
					dir="up"

					#setInGridPosition()	
					
			if Input.is_action_pressed("ui_down"):
				if tilemap.get_cell(gridPosition.x,gridPosition.y+1)== 1:
					lastGridPosition=gridPosition
					gridPosition.y+=1
					velocity = Vector2(0,1)
					onMove=true
					dir="down"
					#setInGridPosition()	
	else:
		pass

func setGridPosition(gpos):
	gridPosition = gpos
	position = gridPosition * 64 + Vector2(32,32)
#	$Label.text = str("X:",gridPosition.x," Y:",gridPosition.y)


	
	pass # Replace with function body.
func setInGridPosition():
#	$Label.text = str("X:",gridPosition.x," Y:",gridPosition.y)

	position = gridPosition * 64 + Vector2(32,32)
	
	#stop movement
	onMove=false
	velocity = Vector2(0,0)
	
	if pControl==true:
		if not world == null:
			world.stepUp()
	
	


func _on_ContactArea_body_entered(body):
	#print("obj",str(body))
	pass # Replace with function body.
func CollideFoe(area):
	#print ("fore")
	pass

func _on_ContactArea_area_entered(area):
	#print("area",str(area))
	pass # Replace with function body.

func stepBack():
	gridPosition=lastGridPosition
	setInGridPosition()
