@tool
extends EditorPlugin

func _enable_plugin():
	add_autoload_singleton("OptionsAutoHandler", "res://addons/options_auto_handler/main.gd")

func _disable_plugin():
	remove_autoload_singleton("OptionsAutoHandler")
