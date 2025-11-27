extends Node
class_name AdapterRegistry

# Folder where all adapter scripts live.
# You can change this or expose it later if needed.
const DEFAULT_ADAPTER_FOLDER := "res://adapters"

@export_dir var adapter_folder: String = DEFAULT_ADAPTER_FOLDER

var _adapters_by_name: Dictionary = {}
var _adapters_by_category: Dictionary = {}
var _adapters_by_event: Dictionary = {}
var _all_adapters: Array = []


func _ready() -> void:
	# On startup, build the registry once.
	_discover_adapters()


# ====================================================================
# PUBLIC API
# ====================================================================


func reload() -> void:
	"""
	Rebuilds the adapter registry by rescanning the adapter folder.
	Safe to call at any time (e.g., from tests).
	"""
	_discover_adapters()


func get_all() -> Array:
	"""
	Returns an array of all registered adapter instances.
	"""
	return _all_adapters


func get_by_name(name: String) -> BaseAdapter:
	"""
	Returns an adapter by its adapter_name metadata, or null if not found.
	"""
	if _adapters_by_name.has(name):
		return _adapters_by_name[name]
	return null


func has_adapter(name: String) -> bool:
	"""
	Returns true if an adapter with this name is registered.
	"""
	return _adapters_by_name.has(name)


func get_by_category(category: String) -> Array:
	"""
	Returns all adapters that belong to a given category.
	"""
	if _adapters_by_category.has(category):
		return _adapters_by_category[category]
	return []


func get_receivers_for_event(event_type: String) -> Array:
	"""
	Returns all adapters that declare support for the given event type.
	"""
	if _adapters_by_event.has(event_type):
		return _adapters_by_event[event_type]
	return []


# ====================================================================
# INTERNAL: DISCOVERY + REGISTRATION
# ====================================================================

func _discover_adapters() -> void:
	_clear_state()

	if not DirAccess.dir_exists_absolute(adapter_folder):
		push_error("AdapterRegistry: Adapter folder does not exist: %s" % adapter_folder)
		return

	var dir := DirAccess.open(adapter_folder)
	if dir == null:
		push_error("AdapterRegistry: Cannot open folder: %s" % adapter_folder)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		# Skip directories and hidden entries.
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue

		if file_name.ends_with(".gd"):
			var script_path := "%s/%s" % [adapter_folder, file_name]
			_try_register_script(script_path)

		file_name = dir.get_next()
		
	print("ADAPTER REGISTRY SUMMARY: ", _adapters_by_name.keys())
	dir.list_dir_end()


	_log_summary()


func _clear_state() -> void:
	_adapters_by_name.clear()
	_adapters_by_category.clear()
	_adapters_by_event.clear()
	_all_adapters.clear()


func _try_register_script(script_path: String) -> void:
	var script := load(script_path)
	if script == null:
		push_warning("AdapterRegistry: Failed to load script at %s" % script_path)
		return

	var instance: BaseAdapter = script.new()
	if not (instance is BaseAdapter):
		# Not an adapter, ignore silently (or warn if you prefer).
		return

	var adapter: BaseAdapter = instance

	# Pull metadata from the adapter.
	var name := adapter.get_adapter_name()
	var category := adapter.get_category()
	var events := adapter.get_supported_events()

	if name == "" or name == null:
		push_warning("AdapterRegistry: Adapter at %s has no adapter_name set. Skipping." % script_path)
		return

	if _adapters_by_name.has(name):
		push_error(
			"AdapterRegistry: Duplicate adapter name '%s' detected at %s. " +
				"Existing adapter will be kept, this one will be skipped."
			% [name, script_path]
		)
		return

	# Track in master list.
	_all_adapters.append(adapter)

	# Index by name.
	_adapters_by_name[name] = adapter

	# Index by category.
	if category == "" or category == null:
		category = "generic"
	if not _adapters_by_category.has(category):
		_adapters_by_category[category] = []
	_adapters_by_category[category].append(adapter)

	# Index by supported events.
	if events is Array:
		for ev in events:
			if typeof(ev) == TYPE_STRING:
				if not _adapters_by_event.has(ev):
					_adapters_by_event[ev] = []
				_adapters_by_event[ev].append(adapter)
			else:
				push_warning(
					"AdapterRegistry: Adapter '%s' reported non-string event type: %s"
					% [name, str(ev)]
				)
	else:
		push_warning(
			"AdapterRegistry: Adapter '%s' get_supported_events() did not return an Array. Got: %s"
			% [name, typeof(events)]
		)


func _log_summary() -> void:
	var adapter_count := _all_adapters.size()
	var category_count := _adapters_by_category.size()
	var event_key_count := _adapters_by_event.size()

	print(
		"[AdapterRegistry] Loaded %d adapter(s), %d categor(ies), %d event key(s) from %s" %
		[adapter_count, category_count, event_key_count, adapter_folder]
	)
