class_name VSliderOption extends VSlider

@export var Option_Key:OptionKeyFloat

func _ready() -> void:
	if Option_Key:
		OptionsAutoHandler.Init_Option(Option_Key.key,Option_Key.default_value)
		var data = OptionsAutoHandler.Fetch_Option(Option_Key.key)
		if data.status == OptionsAutoHandler.ReturnCodes.OK:
			value = int(data.data)
		connect("value_changed",_value_changed)

func _value_changed(value:float) -> void:
	OptionsAutoHandler.Set_Option(Option_Key.key,value)
