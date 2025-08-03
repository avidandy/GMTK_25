extends Node2D

@export var level: FirestormAbility
@export var pickup_sound = "res://assets/sounds/pickup.ogg"

@export_group("Pickup Settings")
@export var lifetime: float = 10.0 # The amount of time before the pickup disappears.

@onready var timer: Timer = $Timer
@onready var progress_bar: TextureProgressBar = $ProgressBar

func _ready():
	# Configure the timer and connect its timeout signal
	timer.wait_time = lifetime
	timer.start()

	# Hide the progress bar initially
	progress_bar.hide()
	
	if get_parent() is Node2D:
		progress_bar.show()
		
func _process(delta):
	# Update the progress bar value based on the timer's remaining time
	progress_bar.value = (timer.time_left/lifetime) * 100
	
func _on_body_entered(body):
	level.fs_level += 1
	print(level.fs_level)
	timer.stop()
	MainUi.display_message(Vector2(150, 300), "Your Fire Storm spell has leveled up to level " + str(level.p_level))
	AudioController.play_sound(pickup_sound, 1)
	queue_free()

# This function is called when the timer runs out
func _on_timer_timeout():
	queue_free()
