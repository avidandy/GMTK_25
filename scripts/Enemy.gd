# scripts/Enemy.gd
extends CharacterBody2D

@export var speed: float = 100.0 # Base enemy movement speed
@export var health: int = 10 # Health for each enemy instance
@export var score: int = 10 # Amount rewarded on enemy death

@export_group("Player Aggro Settings")
@export var aggro_distance: float = 300.0 # Distance at which enemy speeds up towards player
@export var aggro_speed_multiplier: float = 1.5 # How much faster enemy moves when aggro'd

@export_group("Player Stop Zone Settings")
@export var player_stop_distance: float = 75.0 # The distance from player to stop moving (should be radius of player's AttackStopArea)

@export_group("Attack Settings") # New group for attack settings
@export var attack_damage: int = 5 # Damage dealt to player per hit
@export var attack_interval: float = 0.5 # Time between attacks in seconds

@export_group("Avoidance Settings") # New group for avoidance settings
@export var avoidance_radius: float = 50.0 # How close other enemies need to be to trigger avoidance
@export var avoidance_strength: float = 0.3 # How strongly this enemy repels others (0.0 to 1.0, 0.3 for weak force)

@export_group("Pickup Drop Settings") # Updated: Group for pickup settings
@export var pickup_scenes: Array[PackedScene] # UPDATED: An array to hold multiple pickup scenes
@export var drop_chance: float = 0.5 # Chance (0.0 to 1.0) for the enemy to drop a pickup

@export_group("Sprite Randomization") # NEW: Group for sprite randomization settings
@export var spritesheet: Texture2D # The Texture containing the enemy sprites
@export var sprite_regions: Array[Rect2] # The list of Rectangles defining the regions on the spritesheet

@onready var attack_timer = $AttackTimer # Reference to the AttackTimer node

@export_group("Sounds")
@export var hit_sound = "res://assets/sounds/monster_hit.wav"
@export var death_sound = "res://assets/sounds/monster_death.wav"

@onready var sprite :=$Sprite2D
var direction:= Vector2.ZERO

@export var bobbing_h: float = 5
@export var bobbing_s: float = 3
var bobbing_t:= 0.0

var is_hit := false
var hit_freeze_duration := 0.15

# Reference to the player node
var player: Node2D

func _ready():
	add_to_group("enemies") # Ensure enemy is in "enemies" group

	# Get player reference more robustly by group
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Enemy: Player node not found.")
		# Consider stopping or queue_free() if player is essential
		
	# Set attack timer wait time from export variable
	attack_timer.wait_time = attack_interval

	# NEW: Set up the sprite with a random region from the spritesheet
	if spritesheet and not sprite_regions.is_empty():
		sprite.texture = spritesheet
		sprite.region_enabled = true
		sprite.region_rect = sprite_regions[randi() % sprite_regions.size()]
		
func _physics_process(delta: float) -> void:
	if is_hit:
		return
	
	if velocity.length() > 0.1:
		sprite.rotation = velocity.angle()
		bobbing_t += delta
		var offset_y = sin(bobbing_t * bobbing_s) * bobbing_h
		sprite.position.y = offset_y
		
	if not player or not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_collide(velocity * delta)
		# Stop attack timer if player is gone
		if not attack_timer.is_stopped():
			attack_timer.stop()
		return

	var distance_to_player = global_position.distance_to(player.global_position)

	# --- Player Stop Zone Logic & Attack Timer Management ---
	if distance_to_player < player_stop_distance:
		velocity = Vector2.ZERO # Stop moving when within the attack zone
		if attack_timer.is_stopped(): # Start timer only if it's not already running
			attack_timer.start()
		move_and_collide(velocity * delta) # Ensure it handles collisions even when stopped
		return # Exit early, no need for further movement calculations
	else: # If enemy is outside the stop zone
		if not attack_timer.is_stopped(): # Stop timer if enemy leaves the zone
			attack_timer.stop()
	# -------------------------------------------------------
	
	var target_direction = (player.global_position - global_position).normalized()
	var current_speed = speed

	# --- Avoidance Logic ---
	var avoidance_vector = Vector2.ZERO
	var all_enemies = get_tree().get_nodes_in_group("enemies")
	for other_enemy in all_enemies:
		if other_enemy == self or not is_instance_valid(other_enemy):
			continue

		var distance = global_position.distance_to(other_enemy.global_position)
		if distance > 0 and distance < avoidance_radius:
			# Calculate vector pointing away from other enemy
			var direction_away = (global_position - other_enemy.global_position).normalized()
			# Add to avoidance_vector, stronger repulsion for closer enemies
			avoidance_vector += direction_away * (1.0 - (distance / avoidance_radius))
	
	# Normalize avoidance_vector to prevent over-strong repulsion from many enemies
	if avoidance_vector.length() > 0:
		avoidance_vector = avoidance_vector.normalized() * avoidance_strength

	# Combine movement towards player and avoidance
	# The avoidance_vector is added as a weak force to the movement towards the player.
	var final_direction = (target_direction + avoidance_vector).normalized()

	# --- Player Aggro Speed-Up ---
	if global_position.distance_to(player.global_position) < aggro_distance:
		current_speed *= aggro_speed_multiplier
	# -----------------------------

	velocity = final_direction * current_speed
	move_and_collide(velocity * delta)

func take_damage(amount: int):
	if is_hit: return

	AudioController.play_sound(hit_sound, -5)
	health -= amount
	is_hit = true
	sprite.modulate = Color(1.0, 0.4, 0.4)
	
	await get_tree().create_timer(hit_freeze_duration).timeout
	sprite.modulate = Color(1, 1, 1, 1)
	is_hit = false
	# You can add visual feedback for damage here (e.g., flash red)
	if health <= 0:
		AudioController.play_sound(death_sound, 1)
		ScoreController.increase_score(score)
		
				# UPDATED: Random pickup drop from an array
		if randf() <= drop_chance:
			if not pickup_scenes.is_empty():
				var chosen_scene = pickup_scenes[randi() % pickup_scenes.size()]
				var pickup_instance = chosen_scene.instantiate()
				get_parent().add_child(pickup_instance)
				pickup_instance.global_position = global_position
				print("Enemy dropped a random pickup!")
				
		queue_free() # Remove the enemy when it runs out of health

# --- Attack Timer Signal ---
func _on_AttackTimer_timeout():
	# Check if player still exists and is valid before dealing damage
	if player and is_instance_valid(player):
		# Make sure the player has a take_damage method
		if player.has_method("take_damage"):
			player.take_damage(attack_damage)
			print("Enemy attacked Player for ", attack_damage, " damage.") # For debugging
		else:
			print("Player does not have a 'take_damage' method!")
	else:
		# If player is gone, stop the attack timer to avoid errors
		attack_timer.stop()
