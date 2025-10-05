class_name ESCLoggerBase
# Perform emergency savegame
signal perform_emergency_savegame

# Sends the error or warning message in the signal
signal error_message(message)

# Valid log levels
enum { LOG_ERROR, LOG_WARNING, LOG_INFO, LOG_DEBUG, LOG_TRACE }

# Log file format
const LOG_FILE_FORMAT: String = "log_%s_%s.log"

# A map of log level names to log level ints
var _level_map: Dictionary = {
	"ERROR": LOG_ERROR,
	"WARNING": LOG_WARNING,
	"INFO": LOG_INFO,
	"DEBUG": LOG_DEBUG,
	"TRACE": LOG_TRACE,
}

# Configured log level
var _log_level: int

# If true, assert() functions will not be called, thus the program won't exit or error.
# Resets to false after an assert() call was ignored once.
var dont_assert: bool = false


# Constructor
func _init():
	_log_level = _level_map[ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.LOG_LEVEL
	).to_upper()]

func formatted_message(context: String, msg: String, letter: String) -> String:
	return "ESC ({0}) {1} {2}: {3}".format([_formatted_date(), letter, context, msg])

# Trace log
func trace(owner: Object, msg: String):
	var context: String = owner.get_script().resource_path.get_file()
	trace_message(context, msg)

# Direct message trace log (requiring a string for the context)
func trace_message(context: String, msg: String):
	print(formatted_message(context, msg, "T"))


# Debug log
func debug(owner: Object, msg: String):
	var context: String = owner.get_script().resource_path.get_file()
	debug_message(context, msg)

# Static debug log (requiring a string for the context)
func debug_message(context: String, msg: String):
	print(formatted_message(context, msg, "D"))


func info(owner: Object, msg: String):
	var context: String = owner.get_script().resource_path.get_file()
	info_message(context, msg)

# Static info log (requiring a string for the context)
func info_message(context: String, msg: String):
	print(formatted_message(context, msg, "I"))


# Warning log
func warn(owner: Object, msg: String):
	var context: String = owner.get_script().resource_path.get_file()
	warn_message(context, msg)

# Static warning log (requiring a string for the context)
func warn_message(context: String, msg: String):
	print(formatted_message(context, msg, "W"))
	push_warning(formatted_message(context, msg, "W"))
	if ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.TERMINATE_ON_WARNINGS
	):
		if not dont_assert:
			assert(false)
			escoria.get_tree().quit()
		dont_assert = false
		emit_signal("error_message", msg)


# Error log
func error(owner: Object, msg: String):
	var context = owner.get_script().resource_path.get_file()
	error_message_f(context, msg)

# Static error log (requiring a string for the context)
func error_message_f(context: String, msg: String):
	printerr(formatted_message(context, msg, "E"))
	push_error(formatted_message(context, msg, "E"))
	if ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.TERMINATE_ON_ERRORS
	):
		if not dont_assert:
			assert(false)
			escoria.get_tree().quit()
		dont_assert = false
		emit_signal("error_message", msg)

func get_log_level() -> int:
	return _log_level


func _formatted_date():
	var info = Time.get_datetime_dict_from_system()
	info["year"] = "%04d" % info["year"]
	info["month"] = "%02d" % info["month"]
	info["day"] = "%02d" % info["day"]
	info["hour"] = "%02d" % info["hour"]
	info["minute"] = "%02d" % info["minute"]
	info["second"] = "%02d" % info["second"]
	return "{year}-{month}-{day}T{hour}:{minute}:{second}".format(info)
