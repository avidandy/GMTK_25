extends RichTextLabel

func _ready():
	var score_controller = get_node("/root/ScoreController")
	score_controller.connect("score_changed", Callable(self, "_on_score_changed"))
	
func _on_score_changed(new_score):
	text = "Score: %d" % new_score
