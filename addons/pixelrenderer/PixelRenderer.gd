extends Node2D


# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

# Camera setup
@export_subgroup("Camera")
@export var max_resolution: Vector2i
@export var base_resolution: Vector2i

@onready var width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var height = ProjectSettings.get_setting("display/window/size/viewport_height")

@onready var base_zoom = Vector2(width / float(base_resolution[0]), height / float(base_resolution[1]))

# Camera movement
var aim_zoom
@export_range(0.0, 1.0) var zoom_lerp_weight = 0.1

# Scene
@export_subgroup("Scene")
@export var render_starting_scene = true

var current_scene = null

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
	# Camera setup
	viewport.size = max_resolution
	
	camera.zoom = base_zoom
	aim_zoom = base_zoom
	
	call_deferred("_scene_setup")


func _scene_setup():
	if render_starting_scene:
		var root = get_tree().get_root()
		current_scene = root.get_child(root.get_child_count() - 1)
		current_scene.reparent(viewport)


func _process(delta):
	# Zoom
	camera.zoom = lerp(camera.zoom, aim_zoom, zoom_lerp_weight)


# ------------------------------------------------------------------------------
# METHODS
# ------------------------------------------------------------------------------

# Applies a zoom by the given factor. Limited by max_resolution
func zoom_by(factor: float):
	factor = max(factor, max_resolution[0] / float(width), max_resolution[1] / float(height))
	
	aim_zoom = base_zoom * factor


# Frees the scene currently being rendered
func stop_render():
	if current_scene != null:
		current_scene.free()


# Instantiates a new scene on the renderer
func render(path):
	stop_render()
	
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	
	viewport.add_child(current_scene)
