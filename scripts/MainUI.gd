# scripts/MainUI.gd
extends CanvasLayer

@onready var player_health_bar = $HealthBarContainer/PlayerHealthBar
@onready var health_label = $HealthBarContainer/RichTextLabel # If you want to show HP numbers

func _ready():
	var player_node = get_tree().get_first_node_in_group("player")
	if player_node:
		player_node.health_changed.connect(_on_player_health_changed)
		# Ensure initial state is set
		player_health_bar.max_value = player_node.max_health
		player_health_bar.value = player_node.current_health
		health_label.text = str(player_node.current_health) + "/" + str(player_node.max_health)
	else:
		print("UI: Player node not found. Health bar will not update.")

func _on_player_health_changed(current_hp: int, max_hp: int):
	player_health_bar.max_value = max_hp
	player_health_bar.value = current_hp
	health_label.text = str(current_hp) + "/" + str(max_hp)
