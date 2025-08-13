class_name CodeEditOption extends CodeEdit

@export var Option_Key:OptionKeyString

func _ready() -> void:
	if Option_Key:
		OptionsAutoHandler.Init_Option(Option_Key.key,Option_Key.default_value)
		var data = OptionsAutoHandler.Fetch_Option(Option_Key.key)
		if data.status == OptionsAutoHandler.ReturnCodes.OK:
			text = str(data.data)
		connect("text_changed",_text_changed)

func _text_changed() -> void:
	OptionsAutoHandler.Set_Option(Option_Key.key,text)
