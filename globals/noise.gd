extends Node

var noise
var seed

func _ready():
	seed = randf() * 345
	noise = FastNoiseLite.new()
	noise.seed = seed
	noise.frequency = 2.3
	noise.fractal_octaves = 6
	noise.fractal_gain = 1;


func n21(vector2):
	return noise.get_noise_2d(vector2.x, vector2.y) * 3.
