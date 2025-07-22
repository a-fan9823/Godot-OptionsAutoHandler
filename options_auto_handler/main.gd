extends Node

## Variables prefixed by an underscore are absolutely not to be manually modified or used and may break things otherwise! 

@export var SaveOnChange: bool = true
@export var SaveOnQuit: bool = true
@export var LoadOnLaunch: bool = true
@export var options_file: String = "user://user_data/Options.json"

const _plugin_name: String = "OptionsAutoHandler"
const _INDICATOR_CHR: String = '￼'

var _dirty: bool = false
var _LoadedOptions: Dictionary = {}
var _DefaultOptions: Dictionary = {}

## Return codes for API methods
enum ReturnCodes {
	PARAM_NOT_FOUND,
	PARAM_ALREADY_EXISTS,
	UNKNOWN_ERROR,
	PARAM_NAME_ERROR,
	PRIVATE_API_ERROR,
	OK,
	FILE_WRITE_ERROR,
	FILE_READ_ERROR,
	CORRUPT_DATA
}

## API Signals
signal OptionInitialized(option_key: String)
signal OptionUpdated(option_key: String, new_value: Variant)
signal OptionRemoved(option_key: String)
signal OptionsSaved()
signal OptionsLoaded()

func Init_Option(OptionKey: String, DefaultValue: Variant = null) -> int:
	if OptionKey.is_empty():
		push_error(_plugin_name + ": OptionKey may not be empty.")
		return ReturnCodes.PARAM_NAME_ERROR

	if _DefaultOptions.has(OptionKey):
		push_warning(_plugin_name + ": OptionKey \"" + OptionKey + "\" already initialized.")
		return ReturnCodes.PARAM_ALREADY_EXISTS

	_DefaultOptions[OptionKey] = DefaultValue
	_LoadedOptions.get_or_add(OptionKey, DefaultValue)
	_dirty = true
	emit_signal("OptionInitialized", OptionKey)
	return ReturnCodes.OK

func Fetch_Option(OptionKey: String) -> Dictionary:
	if !_LoadedOptions.has(OptionKey):
		push_warning(_plugin_name + ": OptionKey \"" + OptionKey + "\" not found.")
		return { "status": ReturnCodes.PARAM_NOT_FOUND, "data": null }
	return { "status": ReturnCodes.OK, "data": _LoadedOptions[OptionKey] }

func Fetch_Option_Default(OptionKey: String) -> Dictionary:
	if !_DefaultOptions.has(OptionKey):
		push_warning(_plugin_name + ": Default OptionKey \"" + OptionKey + "\" not found.")
		return { "status": ReturnCodes.PARAM_NOT_FOUND, "data": null }
	return { "status": ReturnCodes.OK, "data": _DefaultOptions[OptionKey] }

func Set_Option(OptionKey: String, Value: Variant) -> int:
	if !_LoadedOptions.has(OptionKey):
		push_warning(_plugin_name + ": OptionKey \"" + OptionKey + "\" not found.")
		return ReturnCodes.PARAM_NOT_FOUND
	_LoadedOptions[OptionKey] = Value
	_dirty = true
	emit_signal("OptionUpdated", OptionKey, Value)
	return ReturnCodes.OK

func Set_Option_Default(OptionKey: String, Value: Variant) -> int:
	if !_DefaultOptions.has(OptionKey):
		push_warning(_plugin_name + ": Default OptionKey \"" + OptionKey + "\" not found.")
		return ReturnCodes.PARAM_NOT_FOUND
	_DefaultOptions[OptionKey] = Value
	return ReturnCodes.OK

func Remove_Option(OptionKey: String) -> int:
	if !_DefaultOptions.has(OptionKey):
		push_warning(_plugin_name + ": OptionKey \"" + OptionKey + "\" not found.")
		return ReturnCodes.PARAM_NOT_FOUND
	_DefaultOptions.erase(OptionKey)
	_LoadedOptions.erase(OptionKey)
	_dirty = true
	emit_signal("OptionRemoved", OptionKey)
	return ReturnCodes.OK

func Save_Options_To_Disk() -> int:
	if !DirAccess.dir_exists_absolute(options_file.get_base_dir()):
		DirAccess.make_dir_absolute(options_file.get_base_dir())
	var file := FileAccess.open(options_file, FileAccess.WRITE)
	if file == null:
		push_error(_plugin_name + ": Failed to open file for writing: " + options_file)
		return ReturnCodes.FILE_WRITE_ERROR
	var sanitized: Dictionary = sanitize_json(_LoadedOptions)
	file.store_string(JSON.stringify(sanitized, "\t"))
	file.close()
	emit_signal("OptionsSaved")
	return ReturnCodes.OK

func Load_Options_From_Disk() -> int:
	if !FileAccess.file_exists(options_file):
		return ReturnCodes.FILE_READ_ERROR
	var file := FileAccess.open(options_file, FileAccess.READ)
	if file == null:
		push_error(_plugin_name + ": Failed to open file for reading: " + options_file)
		return ReturnCodes.FILE_READ_ERROR
	var json_text: String = file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(json_text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning(_plugin_name + ": Invalid or corrupt options file.")
		return ReturnCodes.CORRUPT_DATA
	_LoadedOptions = unsanitize_json(parsed)
	for key: String in _DefaultOptions.keys():
		if !_LoadedOptions.has(key):
			_LoadedOptions[key] = _DefaultOptions[key]
	emit_signal("OptionsLoaded")
	return ReturnCodes.OK

# --- Internal Helpers ---

func sanitize_json(value: Variant) -> Variant:
	match typeof(value):
		TYPE_DICTIONARY:
			var d: Dictionary = {}
			for k in value:
				d[k] = sanitize_json(value[k])
			return d
		TYPE_ARRAY:
			var a: Array = []
			for v in value:
				a.append(sanitize_json(v))
			return a
		TYPE_FLOAT:
			if is_nan(value):
				return _INDICATOR_CHR + "NaN" + _INDICATOR_CHR
			elif value == INF:
				return _INDICATOR_CHR + "INF" + _INDICATOR_CHR
			elif value == -INF:
				return _INDICATOR_CHR + "-INF" + _INDICATOR_CHR
			else:
				return value
		_:
			return value

func unsanitize_json(value: Variant) -> Variant:
	match typeof(value):
		TYPE_DICTIONARY:
			var d: Dictionary = {}
			for k in value:
				d[k] = unsanitize_json(value[k])
			return d
		TYPE_ARRAY:
			var a: Array = []
			for v in value:
				a.append(unsanitize_json(v))
			return a
		TYPE_STRING:
			if value.begins_with(_INDICATOR_CHR) and value.ends_with(_INDICATOR_CHR):
				var content: String = value.substr(1, value.length() - 2)
				match content:
					"NaN": return NAN
					"INF": return INF
					"-INF": return -INF
					_: return value
			return value
		_:
			return value

# --- Misc ---

func _process(_delta: float) -> void:
	if SaveOnChange and _dirty:
		Save_Options_To_Disk()

func _exit_tree() -> void:
	if SaveOnQuit:
		Save_Options_To_Disk()

func _ready() -> void:
	if LoadOnLaunch:
		Load_Options_From_Disk()
