extends ESCLoggerBase
# A logger that logs to the terminal and to a log file.
class_name ESCLoggerFile 
# Log file handler
var log_file: FileAccess

# Constructor
func _init():
	# Open logfile in write mode
	# This is left alone as this constructor is called from escoria.gd's own
	super._init()
	# constructor
	var log_file_path = ProjectSettings.get_setting(
		ESCProjectSettingsManager.LOG_FILE_PATH
	)			
	
	var date = Time.get_datetime_dict_from_system()
	log_file_path = (log_file_path+ "/" +LOG_FILE_FORMAT % [
			str(date["year"]) + str(date["month"]) + str(date["day"]),
			str(date["hour"]) + str(date["minute"]) + str(date["second"])
		])
	log_file = FileAccess.open(
		log_file_path,
		FileAccess.WRITE
	)

# Trace log
func trace(owner: Object, msg: String):
	if _log_level >= LOG_TRACE:
		_log_to_file(owner, msg, "T")
		super.trace(owner, msg)

# Static trace log
func trace_message(context: String, msg: String):
	if _log_level >= LOG_TRACE:
		_log_to_file_message(context, msg, "T")
		super.trace_message(context, msg)

# Debug log
func debug(owner: Object, msg: String):
	if _log_level >= LOG_DEBUG:
		_log_to_file(owner, msg, "D")
		super.debug(owner, msg)

# Static debug log
func debug_message(context: String, msg: String):
	if _log_level >= LOG_DEBUG:
		_log_to_file_message(context, msg, "D")
		super.debug_message(context, msg)

# Info log
func info(owner: Object, msg: String):
	if _log_level >= LOG_INFO:
		_log_to_file(owner, msg, "I")
		super.info(owner, msg)
		print(msg)

# Static info log
func info_message(context: String, msg: String):
	if _log_level >= LOG_INFO:
		_log_to_file_message(context, msg, "I")
		super.info_message(context, msg)

# Warning log
func warn(owner: Object, msg: String):
	if _log_level >= LOG_WARNING:
		_log_to_file(owner, msg, "W")
		if ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.TERMINATE_ON_WARNINGS
		):
			_log_stack_trace_to_file()
			print_stack()
			close_logs()
		super.warn(owner, msg)

# Static warning log
func warn_message(context: String, msg: String):
	if _log_level >= LOG_WARNING:
		_log_to_file_message(context, msg, "W")
		if ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.TERMINATE_ON_WARNINGS
		):
			_log_stack_trace_to_file()
			print_stack()
			close_logs()
		super.warn_message(context, msg)

# Error log
func error(owner: Object, msg: String):
	if _log_level >= LOG_ERROR:
		_log_to_file(owner, msg, "E")
		if ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.TERMINATE_ON_ERRORS
		):
			_log_stack_trace_to_file()
			print_stack()
			close_logs()
		super.error(owner, msg)

# Static eror log
func log_error_message(context: String, msg: String):
	if _log_level >= LOG_ERROR:
		_log_to_file_message(context, msg, "E")
		if ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.TERMINATE_ON_ERRORS
		):
			_log_stack_trace_to_file()
			print_stack()
			close_logs()
			log_error_message(context, msg)

# Close the log file cleanly
func close_logs():
	print("Closing logs peacefully.")
	_log_line_to_file("Closing logs peacefully.")
	log_file.close()


func _log_to_file(owner: Object, msg: String, letter: String):
	var context: String
	if owner != null:
		context = owner.get_script().resource_path.get_file()
		_log_to_file_message(context, msg, letter)
	else:
		print(msg)

func _log_to_file_message(context: String, msg: String, letter: String):
	if log_file.is_open():
		log_file.store_string(formatted_message(context, msg, letter) + "\n")
	else:
		print(msg)

func _log_line_to_file(msg: String):
	if log_file.is_open():
		log_file.store_string(msg + "\n")
	else:
		print(msg)
		
func _log_stack_trace_to_file():
	var frame_number = 0
	for stack in get_stack().slice(2, get_stack().size()):
		_log_line_to_file(
			"Frame %s - %s:%s in function '%s'" % [
				str(frame_number),
				stack["source"],
				stack["line"],
				stack["function"],
			]
		)
		frame_number += 1
