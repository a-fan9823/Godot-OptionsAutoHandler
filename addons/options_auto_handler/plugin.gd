@tool
extends EditorPlugin

const _CUSTOM_NODES := [
	[
		"CheckBoxOption",
		"CheckBox",
		preload("res://addons/options_auto_handler/nodes/CheckBoxOption.gd"),
		preload("res://addons/options_auto_handler/icons/checkbox_option.svg")
	],
	[
		"CheckButtonOption",
		"CheckButton",
		preload("res://addons/options_auto_handler/nodes/CheckButtonOption.gd"),
		preload("res://addons/options_auto_handler/icons/checkbutton_option.svg")
	],
	[
		"LineEditOption",
		"LineEdit",
		preload("res://addons/options_auto_handler/nodes/LineEditOption.gd"),
		preload("res://addons/options_auto_handler/icons/lineedit_option.svg")
	],
	[
		"TextEditOption",
		"TextEdit",
		preload("res://addons/options_auto_handler/nodes/TextEditOption.gd"),
		preload("res://addons/options_auto_handler/icons/textedit_option.svg")
	],
	[
		"CodeEditOption",
		"CodeEdit",
		preload("res://addons/options_auto_handler/nodes/CodeEditOption.gd"),
		preload("res://addons/options_auto_handler/icons/codeedit_option.svg")
	],
	[
		"OptionButtonOption",
		"OptionButton",
		preload("res://addons/options_auto_handler/nodes/OptionButtonOption.gd"),
		preload("res://addons/options_auto_handler/icons/optionbutton_option.svg")
	],
	[
		"HSliderOption",
		"HSlider",
		preload("res://addons/options_auto_handler/nodes/HSliderOption.gd"),
		preload("res://addons/options_auto_handler/icons/hslider_option.svg")
	],
	[
		"VSliderOption",
		"VSlider",
		preload("res://addons/options_auto_handler/nodes/VSliderOption.gd"),
		preload("res://addons/options_auto_handler/icons/vslider_option.svg")
	],
	[
		"SpinBoxOption",
		"SpinBox",
		preload("res://addons/options_auto_handler/nodes/SpinBoxOption.gd"),
		preload("res://addons/options_auto_handler/icons/spinbox_option.svg")
	]
]

func _enable_plugin():
	add_autoload_singleton("OptionsAutoHandler", "res://addons/options_auto_handler/main.gd")
	for node in _CUSTOM_NODES:
		add_custom_type(node[0], node[1], node[2], node[3])

func _disable_plugin():
	remove_autoload_singleton("OptionsAutoHandler")
	for node in _CUSTOM_NODES:
		remove_custom_type(node[0])
