extends Control

var T = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T += delta
	if T > 2:
		if fmod(T*2, 2) > 1:
			$continue_text.show()
		else:
			$continue_text.hide()
	pass

func _input(event):
	if Score.is_game_over && T > 2:
		Score.start_game()

func start():
	T = 0
	$animation.play("game_over")

func set_score(score):
	$score_text.text = 'Score: ' + str(Score.score)
