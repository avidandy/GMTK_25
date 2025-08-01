# scripts/Enemy.gd
extends CharacterBody2D

@export var speed: float = 100.0 # Base enemy movement speed
@export var health: int = 10 # Health for each enemy instance

@export_group("Player Aggro Settings")
@export var aggro_distance: float = 300.0 # Distance at which enemy speeds up towards player
@export var aggro_speed_multiplier: float = 1.5 # How much faster enemy moves when aggro'd

@export_group("Player Stop Zone Settings")
@export var player_stop_distance: float = 75.0 # The distance from player to stop moving (should be radius of player's AttackStopArea)

@export_group("Attack Settings") # New group for attack settings
@export var attack_damage: int = 5 # Damage dealt to player per hit
@export var attack_interval: float = 0.5 # Time between attacks in seconds

@onready var attack_timer = $AttackTimer # Reference to the AttackTimer node

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

func _physics_process(delta: float) -> void:
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

	# --- Player Aggro Speed-Up ---
	if global_position.distance_to(player.global_position) < aggro_distance:
		current_speed *= aggro_speed_multiplier
	# -----------------------------

	# Combine movement and avoidance
	# The avoidance_vector is added. You might want to weigh it differently
	# or use a blend, depending on how strong you want avoidance to be.
	var final_direction = (target_direction).normalized()

	velocity = final_direction * current_speed
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	# You can add visual feedback for damage here (e.g., flash red)
	if health <= 0:
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
