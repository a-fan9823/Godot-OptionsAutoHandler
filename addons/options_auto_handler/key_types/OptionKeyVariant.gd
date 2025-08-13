class_name OptionKeyVariant extends Resource

@export var key:String

## [center][u][b][color=maroon]IMPORTANT:[/color][/b][/u]  This field is [b]not[/b] a true [i]Array[/i]. It is a workaround because Godot does not currently support exporting Variant types directly.  Only the [b]first[/b] value entered will be stored — [b]all other elements will be ignored or [color=maroon]permanently removed[/color][/b].  [br][b][u]Edit carefully — you have been warned![/u][/b]
@export var default_value:Array:
	set(data):
		if !data.is_empty():
			default_value = [data[0]]
	get():
		if !default_value.is_empty():
			return [default_value[0]]
		else:
			return []
