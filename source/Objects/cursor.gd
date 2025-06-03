extends Node2D

# Grid movement variables
var gpos = Vector2.ZERO
var gsize = 16
var gridDim = Vector2(1, 1)

# Movement control
var move = false
var canMove = true
var onRestrictedMode = false  # Restriction flag

func _ready():
	pass

func _process(delta):
	if move and canMove:
		if Input.is_action_just_pressed("ui_right"):
			move_to_cell(gpos + Vector2.RIGHT)
		elif Input.is_action_just_pressed("ui_left"):
			move_to_cell(gpos + Vector2.LEFT)
		elif Input.is_action_just_pressed("ui_up"):
			move_to_cell(gpos + Vector2.UP)
		elif Input.is_action_just_pressed("ui_down"):
			move_to_cell(gpos + Vector2.DOWN)

func move_to_cell(target_cell: Vector2):
	if onRestrictedMode:
		if Global.world.position_is_enabledCell(target_cell):
			gpos = target_cell
	else:
		gpos = target_cell
	Global.world.check_cursor_hover_unit(gpos)
	set_grid_pos()

func set_grid_pos():
	# Clamp grid position within bounds
	gpos.x = clamp(gpos.x, 0, gridDim.x - 1)
	gpos.y = clamp(gpos.y, 0, gridDim.y - 1)

	# Apply movement to node position
	position = gpos * gsize

	# Restart movement cooldown timer
	move = false
	$Timer.start()

	# Update parent node display
	Global.world.dataDisplay.update_data_display(Global.world.hoverUnit)

func get_grid_pos():
	return gpos

func _on_Timer_timeout():
	move = true  # Re-enable movement after timer delay
