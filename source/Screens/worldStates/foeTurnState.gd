extends "res://addons/fsmgear/source/FsmState.gd"

var endstate: bool = false
var timer: Timer
var times: int = 0

# Called when the state is entered
func enter(actowner: Node) -> void:
	endstate = false
	times = 0
	
	# Create a new Timer if it doesn't exist
	if timer == null:
		timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.wait_time = 3.0 # Set the timer duration in seconds
		timer.timeout.connect(_on_timer_timeout.bind(actowner)) # Use bind to pass actowner to the timeout function
	
	# Start the Timer
	timer.start()

# Function called when the timer times out
func _on_timer_timeout(actowner: Node) -> void:
	# Check the condition based on actowner's state
	if actowner.get_disable_active_unit("blue"):
		timer.start() # Restart the timer
	else:
		endstate = true

# Function to check if the state has ended
func state_ended() -> bool:
	return endstate
