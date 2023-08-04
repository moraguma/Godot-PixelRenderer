extends Camera2D

@export var aim_resolution: Vector2      

@onready var width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var height = ProjectSettings.get_setting("display/window/size/viewport_height")


@onready var rect = $Rect


func _ready():
	rect.material.set_shader_parameter("aimRes", aim_resolution)


func _process(delta):
	var effective_width = width / zoom[0]
	var effective_height = height / zoom[1]
	
	rect.scale = Vector2(effective_width / 1920, effective_height / 1080)
	
	rect.material.set_shader_parameter("zoom", zoom)
	
	var top_left = Vector2(-effective_width / 2, -effective_height / 2)
	rect.material.set_shader_parameter("o", Vector2(top_left[0] / aim_resolution[0], top_left[1] / aim_resolution[1]))


func _physics_process(delta):
	var dir = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),\
						Input.get_action_strength("down") - Input.get_action_strength("up"))
	
	if dir != Vector2(0, 0):
		pass
	position += dir * 300 * delta
	
	if Input.is_action_pressed("zoom"):
		zoom += Vector2(1, 1) * delta
	elif Input.is_action_pressed("unzoom"):
		zoom -= Vector2(1, 1) * delta
