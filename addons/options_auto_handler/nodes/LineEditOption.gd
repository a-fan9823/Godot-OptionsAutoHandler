class_name LineEditOption extends LineEdit

@export var Option_Key:OptionKeyString
@export var Save_on_Submit:=true
@export var Save_Live:=false

func _ready() -> void:
	if Option_Key:
		OptionsAutoHandler.Init_Option(Option_Key.key,Option_Key.default_value)
		var data = OptionsAutoHandler.Fetch_Option(Option_Key.key)
		if data.status == OptionsAutoHandler.ReturnCodes.OK:
			text = str(data.data)
		if Save_on_Submit:
			connect("text_submitted",_text_submitted)
		if Save_Live:
			connect("text_changed",_text_submitted)

func _text_submitted(new_text:String) -> void:
	OptionsAutoHandler.Set_Option(Option_Key.key,new_text)
