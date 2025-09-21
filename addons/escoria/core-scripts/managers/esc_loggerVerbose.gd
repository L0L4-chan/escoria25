extends ESCLoggerBase
# A simple logger that logs to terminal using debug() function
class_name ESCLoggerVerbose
func _init():
	pass

func debug(owner: Object, msg: String):
	var context = owner.get_script().resource_path.get_file()
	print(context, ": ", msg)
