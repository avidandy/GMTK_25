extends Control

func _ready():
	$MarginContainer/VBoxContainer/PlayButton.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	AudioController.play_sound("res://assets/sounds/click1.wav", 1)
