extends PointLight2D

var light_energy: float


func _ready() -> void:
	tween_flame()




func tween_flame():
	var tween = create_tween()
	light_energy = randf_range(0.3, .8)
	tween.tween_property(self,"energy",light_energy,.4)
	await tween.finished
	await get_tree().create_timer(.5).timeout
	tween_flame()
