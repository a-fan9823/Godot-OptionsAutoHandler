class_name OptionButtonOption extends OptionButton

@export var Option_Key:OptionKeyInt

func _ready() -> void:
	if Option_Key:
		OptionsAutoHandler.Init_Option(Option_Key.key,Option_Key.default_value)
		var data = OptionsAutoHandler.Fetch_Option(Option_Key.key)
		if data.status == OptionsAutoHandler.ReturnCodes.OK:
			selected = int(data.data)
		connect("item_selected",_item_selected)

func _item_selected(index:int) -> void:
	OptionsAutoHandler.Set_Option(Option_Key.key,index)
