# scripts/Player.gd
extends CharacterBody2D

@onready var animsprite: AnimatedSprite2D = $AnimatedSprite2D

@export var friction: int = 8
@export var accel: int = 5
var lastDir: String = "front"

@export var speed = 400
@export var max_health: int = 100 # Add max health variable

@onready var ability_ui = $"../UICanvasLayer/TextureRect"

var current_health: int = max_health: # Current health variable
	set(value):
		current_health = clampi(value, 0, max_health) # Clamp health between 0 and max_health
		health_changed.emit(current_health, max_health) # Emit signal when health changes
		if current_health <= 0:
			die() # Call die function if health is zero or less

# Signal to notify UI (and other interested nodes) about health changes
signal health_changed(current_health_val, max_health_val)

func _ready():
	add_to_group("player") # Add player to a group for easy lookup by enemies/spawner
	health_changed.emit(current_health, max_health) # Emit initial health state for UI

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	var input = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	
	if input:
		update_animation(input)
		animsprite.speed_scale = (velocity/speed).distance_to(Vector2.ZERO) + 0.5
	else:
		animsprite.play("idle_" + lastDir)
		animsprite.speed_scale = 0.7
	
	
	var lerp_weight = delta * (accel if input else friction)
	velocity = lerp(velocity, input * speed, lerp_weight)
	
	move_and_collide(velocity * delta)
	
func update_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if  direction.x > 0:
			animsprite.play("move_right")
			lastDir = "right"
		else:
			animsprite.play("move_left")
			lastDir = "left"
	else:
		if direction.y > 0:
			animsprite.play("move_front")
			lastDir = "front"
		else:
			animsprite.play("move_back")
			lastDir = "back"

func take_damage(amount: int):
	current_health -= amount
	# You can add visual feedback here, e.g., modulate sprite color briefly
	print("Player took ", amount, " damage. Current health: ", current_health) # For debugging

func die():
	print("Player died! Game Over.")
	# Handle game over logic here (e.g., show game over screen, restart level)
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("ui_page_up"):
		var random = ability_ui.ability_regions.keys().pick_random()
		$"../UICanvasLayer/TextureRect".set_ability_type(random)
