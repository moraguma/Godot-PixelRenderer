extends Camera2D


# ------------------------------------------------------------------------------
# CONSTANTS
# ------------------------------------------------------------------------------

# Camera shake
const SHAKE = 0.5

const DECAY = 0.8
const MAX_ROLL = 0.15
const TRAUMA_POWER = 2


# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

# Camera shake
@export var shake_max_offset = Vector2(64, 36)

var trauma = 0.0
var aim_rot = 0
var base_rotation = 0
var noise_y = 0
@onready var noise = FastNoiseLite.new()


func _physics_process(delta):
	var dir = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),\
						Input.get_action_strength("down") - Input.get_action_strength("up"))
	
	position += dir * 5 * delta
	
	if Input.is_action_just_pressed("shake"):
		add_trauma()

func _process(delta):
	# Shake
	if trauma:
		trauma = max(trauma - DECAY * delta, 0)
		_shake()
	else:
		rotation = base_rotation


func _shake():
	# Camera shake implementation based on
	# https://kidscancode.org/godot_recipes/2d/screen_shake/
	
	var amount = pow(trauma, TRAUMA_POWER)
	
	rotation = base_rotation + MAX_ROLL * amount * noise.get_noise_1d(noise_y)
	offset[0] = shake_max_offset[0] * amount * noise.get_noise_1d(noise_y)
	offset[1] = shake_max_offset[1] * amount * noise.get_noise_1d(noise_y + 9999)
	
	noise_y += 1


# Adds trauma to the camera shake
func add_trauma(amount = SHAKE):
	trauma = amount
