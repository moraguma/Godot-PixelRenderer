extends Node2D


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

# Camera setup
@export var max_resolution: Vector2i
@export var base_resolution: Vector2i

@onready var width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var height = ProjectSettings.get_setting("display/window/size/viewport_height")

@onready var base_zoom = Vector2(width / float(base_resolution[0]), height / float(base_resolution[1]))

# Camera movement
var aim_zoom
@export_range(0.0, 1.0) var zoom_lerp_weight = 0.1

# ------------------------------------------------------------------------------
# NODES
# ------------------------------------------------------------------------------

@onready var camera = $Camera
@onready var view = $View
@onready var viewport = $Viewport

# ------------------------------------------------------------------------------
# BUILT-INS
# ------------------------------------------------------------------------------

func _ready():
	viewport.size = max_resolution + Vector2i(2, 2)
	
	camera.zoom = base_zoom
	aim_zoom = base_zoom


func _process(delta):
	# Zoom
	camera.zoom = lerp(camera.zoom, aim_zoom, zoom_lerp_weight)


func _physics_process(delta):
	if Input.is_action_just_pressed("zoom"):
		zoom_by(4.0)
	elif Input.is_action_just_pressed("unzoom"):
		zoom_by(2.0/3.0)


# ------------------------------------------------------------------------------
# METHODS
# ------------------------------------------------------------------------------

func zoom_by(factor: float):
	factor = max(factor, max_resolution[0] / float(width), max_resolution[1] / float(height))
	
	aim_zoom = base_zoom * factor
