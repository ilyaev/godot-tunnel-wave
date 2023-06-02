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
			$restart_btn/continue_text.show()
		else:
			$restart_btn/continue_text.hide()
	pass

func start():
	T = 0
	$animation.play("game_over")

func set_score(score):
	$score_text.text = 'Score: ' + str(Score.score)


func _on_texture_button_pressed():
	# OS.shell_open('https://play.google.com/store/apps/details?id=pbartz.games.speedoddity')
	OS.shell_open('https://ilyaev.itch.io/speed-oddity')


func _on_restart_btn_pressed():
	if Score.is_game_over && T > 2:
		Score.start_game()
