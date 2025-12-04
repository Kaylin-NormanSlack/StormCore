# res://core/adapter_registry.gd
extends Node
class_name AdapterRegistry

const DEFAULT_ADAPTER_FOLDER := "res://core/adapters/test_adapters"

@export_dir var adapter_folder: String = DEFAULT_ADAPTER_FOLDER

var _adapters_by_name: Dictionary = {}
var _adapters_by_category: Dictionary = {}
var _adapters_by_event: Dictionary = {}
var _all_adapters: Array = []


func _ready() -> void:
	_discover_adapters()


func reload() -> void:
	_discover_adapters()


func get_all() -> Array:
	return _all_adapters


func get_by_name(name: String) -> BaseAdapter:
	if _adapters_by_name.has(name):
		return _adapters_by_name[name]
	return null


func has_adapter(name: String) -> bool:
	return _adapters_by_name.has(name)


func get_by_category(category: String) -> Array:
	if _adapters_by_category.has(category):
		return _adapters_by_category[category]
	return []


func get_receivers_for_event(event_type: String) -> Array:
	if _adapters_by_event.has(event_type):
		return _adapters_by_event[event_type]
	return []


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
	var file_name: String = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue

		if file_name.ends_with(".gd"):
			var script_path: String = "%s/%s" % [adapter_folder, file_name]
			_try_register_script(script_path)

		file_name = dir.get_next()

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

	var instance: Object = script.new()
	if not (instance is BaseAdapter):
		return

	var adapter := instance as BaseAdapter

	var name: String = adapter.get_adapter_name()
	var category: String = adapter.get_category()
	var events: Array = adapter.get_supported_events()

	if name == "" or name == null:
		push_warning("AdapterRegistry: Adapter at %s has no adapter_name set. Skipping." % script_path)
		return

	if _adapters_by_name.has(name):
		push_error("AdapterRegistry: Duplicate adapter name '%s' detected at %s." % [name, script_path])
		return

	_all_adapters.append(adapter)
	_adapters_by_name[name] = adapter

	if category == "" or category == null:
		category = "generic"
	if not _adapters_by_category.has(category):
		_adapters_by_category[category] = []
	_adapters_by_category[category].append(adapter)

	if events is Array:
		for ev in events:
			if typeof(ev) == TYPE_STRING:
				if not _adapters_by_event.has(ev):
					_adapters_by_event[ev] = []
				_adapters_by_event[ev].append(adapter)
	else:
		push_warning("AdapterRegistry: Adapter '%s' get_supported_events() did not return an Array." % name)


func _log_summary() -> void:
	var adapter_count: int = _all_adapters.size()
	var category_count: int = _adapters_by_category.size()
	var event_key_count: int = _adapters_by_event.size()

	print(
		"[AdapterRegistry] Loaded %d adapter(s), %d categor(ies), %d event key(s) from %s"
		% [adapter_count, category_count, event_key_count, adapter_folder]
	)
