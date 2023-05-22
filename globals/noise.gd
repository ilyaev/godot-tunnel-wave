extends Node

var noise
var random_noise
var seed
var usage = 0

func _ready():
	seed = randf() * 345

	noise = FastNoiseLite.new()
	noise.seed = seed * 2

	random_noise = FastNoiseLite.new()
	random_noise.seed = seed
	random_noise.frequency = 2.3
	random_noise.fractal_octaves = 6
	random_noise.fractal_gain = 1;


func n21(x, y):
	return noise.get_noise_2d(x,y)

func r21(x, y):
	return random_noise.get_noise_2d(x, y)
