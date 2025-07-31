# scripts/Spawner.gd
extends Node2D

@export var enemy_scene: PackedScene # Assign your Enemy.tscn here in the Inspector
@export var spawn_interval: float = 1.0 # Time between individual enemy spawns
@export var spawn_radius: float = 800.0 # Distance from player to spawn enemies (off-screen)
@export var max_enemies_on_screen: int = 50 # Limit concurrent enemies

@onready var spawn_timer = $SpawnTimer # Reference to the Timer node
var player: Node2D # Reference to the player node

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		spawn_timer.wait_time = spawn_interval
		spawn_timer.autostart = true # Start spawning automatically
		spawn_timer.start()
	else:
		print("Spawner: Player node not found. Spawning will not start.")

func _on_SpawnTimer_timeout():
	# Only spawn if player exists and we're under the enemy limit
	if player and is_instance_valid(player) and get_tree().get_nodes_in_group("enemies").size() < max_enemies_on_screen:
		spawn_enemy()

func spawn_enemy():
	var new_enemy = enemy_scene.instantiate()
	get_parent().add_child(new_enemy) # Add enemy as a sibling to Player and Spawner in Main scene

	# Calculate a random position around the player, outside the viewport
	var random_angle = randf() * TAU # TAU is 2 * PI (full circle in radians)
	var spawn_offset = Vector2(cos(random_angle), sin(random_angle)) * spawn_radius
	new_enemy.global_position = player.global_position + spawn_offset
