extends Control
@export var game_over_sound = "res://assets/sounds/game_over.wav"

func _ready():
	$Score.text = "Your final score is: %s" % str(ScoreController.score)
	AudioController.play_sound(game_over_sound, 1)

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
