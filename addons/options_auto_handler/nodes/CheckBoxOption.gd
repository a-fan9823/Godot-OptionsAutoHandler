class_name CheckBoxOption extends CheckBox

@export var Option_Key:OptionKeyBool

func _ready() -> void:
	if Option_Key:
		OptionsAutoHandler.Init_Option(Option_Key.key,Option_Key.default_value)
		var data = OptionsAutoHandler.Fetch_Option(Option_Key.key)
		if data.status == OptionsAutoHandler.ReturnCodes.OK:
			button_pressed = bool(data.data)
		connect("toggled",_on_toggled)

func _on_toggled(toggled_on: bool) -> void:
	OptionsAutoHandler.Set_Option(Option_Key.key,toggled_on)
