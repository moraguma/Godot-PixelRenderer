@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("PixelRenderer", "res://addons/pixelrenderer/PixelRenderer.tscn")


func _exit_tree():
	remove_autoload_singleton("PixelRenderer")
