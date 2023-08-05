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

# Shader
@export var aim_resolution: Vector2      

@onready var width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var height = ProjectSettings.get_setting("display/window/size/viewport_height")

# Camera movement
var aim_zoom = Vector2(1.0, 1.0)
var aim_pos = Vector2(0, 0)
var aim_node: Node2D

@export_range(0.0, 1.0) var zoom_lerp_weight = 0.1
@export_range(0.0, 1.0) var position_lerp_weight = 0.1

# Camera shake
@export var shake_max_offset = Vector2(160, 90)

var trauma = 0.0
var aim_rot = 0
var base_rotation = 0
var noise_y = 0
@onready var noise = FastNoiseLite.new()

# ------------------------------------------------------------------------------
# NODES
# ------------------------------------------------------------------------------

@onready var rect = $Rect

# ------------------------------------------------------------------------------
# BUILT-INS
# ------------------------------------------------------------------------------

func _ready():
	# Shake
	randomize()
	noise.seed = randi()
	noise.frequency = 0.25
	
	# Shader
	rect.material.set_shader_parameter("aimRes", aim_resolution)


func _process(delta):
	# Movement
	var effective_aim_pos = aim_pos
	if aim_node:
		effective_aim_pos = aim_node.position
	
	position = lerp(position, effective_aim_pos, position_lerp_weight)
	zoom = lerp(zoom, aim_zoom, zoom_lerp_weight)
	
	# Shake
	if trauma:
		trauma = max(trauma - DECAY * delta, 0)
		_shake()
	else:
		rotation = base_rotation
	
	# Shader
	var effective_width = width / zoom[0]
	var effective_height = height / zoom[1]
	
	rect.scale = Vector2(effective_width / 128, effective_height / 128)
	
	rect.material.set_shader_parameter("zoom", zoom)
	
	var top_left = Vector2(-effective_width / 2, -effective_height / 2)
	rect.material.set_shader_parameter("o", Vector2(top_left[0] / aim_resolution[0], top_left[1] / aim_resolution[1]))


func _shake():
	# Camera shake implementation based on
	# https://kidscancode.org/godot_recipes/2d/screen_shake/
	
	var amount = pow(trauma, TRAUMA_POWER)
	
	rotation = base_rotation + MAX_ROLL * amount * noise.get_noise_1d(noise_y)
	offset[0] = shake_max_offset[0] * amount * noise.get_noise_1d(noise_y)
	offset[1] = shake_max_offset[1] * amount * noise.get_noise_1d(noise_y + 9999)
	
	noise_y += 1


func _physics_process(delta):
	var dir = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),\
						Input.get_action_strength("down") - Input.get_action_strength("up"))
	
	aim_pos += dir * 300 * delta
	
	if Input.is_action_pressed("zoom"):
		aim_zoom += Vector2(1, 1) * delta
	elif Input.is_action_pressed("unzoom"):
		aim_zoom -= Vector2(1, 1) * delta
	
	if Input.is_action_just_pressed("shake"):
		add_trauma()

# ------------------------------------------------------------------------------
# METHODS
# ------------------------------------------------------------------------------

# Sets a node for the camera to follow
func follow_node(node: Node2D):
	aim_node = node


# Sets a position for the camera to focus on
func focus_on(pos: Vector2):
	aim_node = null
	aim_pos = pos


# Sets a factor for the camera to zoom by
func zoom_by(factor: float):
	aim_zoom = Vector2(factor, factor)


# Adds trauma to the camera shake
func add_trauma(amount = SHAKE):
	trauma = amount
