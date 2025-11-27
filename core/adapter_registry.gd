extends Node
class_name AdapterRegistry

var adapter_folder: String = "res://adapters"
var adapters_by_name: Dictionary = {}
var adapters_by_category: Dictionary = {}
var adapters_by_event: Dictionary = {}
var all_adapters: Array = []




func _ready():
	discover_adapters()


# --------------------------------------------------------------
#   DISCOVERY
# --------------------------------------------------------------

func discover_adapters():
	adapters_by_name.clear()
	adapters_by_category.clear()
	adapters_by_event.clear()
	all_adapters.clear()

	var dir := DirAccess.open(adapter_folder)
	if dir == null:
		push_error("AdapterRegistry: Cannot open folder: %s" % adapter_folder)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".gd"):
			var script_path := "%s/%s" % [adapter_folder, file_name]
			var script := load(script_path)

			if script:
				var instance := script.new() as BaseAdapter

				if instance is BaseAdapter:
					_register_adapter(instance)

		file_name = dir.get_next()

	dir.list_dir_end()


# --------------------------------------------------------------
#   INTERNAL REGISTRATION
# --------------------------------------------------------------

func _register_adapter(adapter: BaseAdapter):
	var name := adapter.get_adapter_name()
	var category := adapter.get_category()
	var events := adapter.get_supported_events()

	# Track raw list
	all_adapters.append(adapter)

	# By name
	adapters_by_name[name] = adapter

	# By category
	if not adapters_by_category.has(category):
		adapters_by_category[category] = []
	adapters_by_category[category].append(adapter)

	# By supported events
	for event_type in events:
		if not adapters_by_event.has(event_type):
			adapters_by_event[event_type] = []
		adapters_by_event[event_type].append(adapter)


# --------------------------------------------------------------
#   PUBLIC API (CLEAN!)
# --------------------------------------------------------------

func get_by_name(name: String) -> BaseAdapter:
	return adapters_by_name.get(name, null)


func get_all() -> Array:
	return all_adapters


func get_by_category(category: String) -> Array:
	return adapters_by_category.get(category, [])


func get_receivers_for_event(event_type: String) -> Array:
	return adapters_by_event.get(event_type, [])


func has_adapter(name: String) -> bool:
	return adapters_by_name.has(name)
