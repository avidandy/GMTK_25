extends Control

func _ready():
	$MarginContainer/VBoxContainer/PlayButton.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_options_button_pressed() -> void:
	# Add logic if needed - I guess volume control is our likely case
	pass 
