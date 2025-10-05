# A cache for resources
extends Node
class_name ESCResourceCache

# signals
signal resource_loading_progress(path, progress)
signal resource_loading_done(path)
signal resource_queue_progress(queue_size)


var queue: Array = []
var pending: Dictionary = {}

# Load and storage the reources
func queue_resource(path: String, p_in_front: bool = false, p_permanent: bool = false):
	if path in pending:
		return

	elif ResourceLoader.has_cached(path):
		var res = ResourceLoader.load(path)
		pending[path] = ESCResourceDescriptor.new(res, p_permanent)
	else:
		var res = ResourceLoader.load_threaded_get(path)
		res.set_meta("path", path)
		if p_in_front:
			queue.insert(0, res)
		else:
			queue.push_back(res)
		pending[path] = ESCResourceDescriptor.new(res, p_permanent)

# Delete de resources from the list
func cancel_resource(path):
	if path in pending:
		if pending[path].res is ResourceLoader:
			queue.erase(pending[path].res)
		pending.erase(path)

# Empty all the resources list
func clear():
	for p in pending.keys():
		if pending[p].permanent:
			continue
		cancel_resource(p)

# Check and emmit a signal depending on the state of the resource
func get_progress(path):
	var ret = -1
	if path in pending:
		if pending[path].res is ResourceLoader:
			ret = float(pending[path].res.get_stage()) / float(pending[path].res.get_stage_count())
		else:
			ret = 1.0
			emit_signal("resource_loading_done", path)
	emit_signal("resource_loading_progress", path, ret)

	return ret

func is_ready(path):
	var ret

	if path in pending:
		ret = !(pending[path].res is ResourceLoader)
	else:
		ret = false

	return ret

func _wait_for_resource(res, path):
	while true:
		RenderingServer.force_sync()
		OS.delay_usec(16000) # wait 1 frame

		if queue.size() == 0 || queue[0] != res:
			return pending[path].res

func get_resource(path):
	if path in pending:
		if pending[path] is ResourceLoader:
			var res = pending[path].res
			if res != queue[0]:
				var pos = queue.find(res)
				queue.remove_at(pos)
				queue.insert(0, res)

			res = _wait_for_resource(res, path)

			if !pending[path].permanent:
				pending.erase(path)

			return res

		else:
			var res = pending[path].res
			if !pending[path].permanent:
				pending.erase(path)

			return res
	else:
		if not ProjectSettings.get_setting("escoria/platform/skip_cache"):
			var res = ResourceLoader.load(path)
			pending[path] = ESCResourceDescriptor.new(res, true)
			return res
		return ResourceLoader.load(path)

func print_progress(p_path, p_progress):
	printt(p_path, "loading", round(p_progress * 100), "%")

func res_loaded(p_path):
	printt("loaded resource", p_path)

func print_queue_progress(p_queue_size):
	printt("queue size:", p_queue_size)

func start():
	pass

func _process(_delta) -> void:
	while queue.size() > 0:
		var res = queue[0]

		var ret = res.poll()

		var path = res.get_meta("path")
		if ret == ERR_FILE_EOF || ret != OK:
			printt("finished loading ", path)
			if path in pending: # else it was already retrieved
				pending[res.get_meta("path")].res = res.get_resource()

			queue.erase(res) # something might have been put at the front of the queue while we polled, so use erase instead of remove
			emit_signal("resource_queue_progress", queue.size())
