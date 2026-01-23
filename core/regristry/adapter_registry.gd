extends Node
class_name AdapterRegistry

const DEFAULT_ADAPTER_FOLDER := "res://core/adapters/"

# name -> Script
var _adapter_scripts: Dictionary = {}

var _adapter_instances: Dictionary = {}

func _ready() -> void:
	self.add_to_group("adapter_registry")

# -----------------------------
# Public API
# -----------------------------

func reload() -> void:
	_adapter_scripts.clear()
	_discover_adapters()

func get_all_scripts() -> Array:
	return _adapter_scripts.values()

func get_instance(name: String) -> BaseAdapter:
	return _adapter_instances.get(name, null)



func get_adapter_script(name: String) -> Script:
	return _adapter_scripts.get(name, null)

func register_instance(adapter: BaseAdapter) -> void:
	if adapter == null:
		return

	var adapter_name := adapter.get_class()
	if adapter_name == "":
		push_error("AdapterRegistry: Instance has no class_name")
		return

	# Optional: ensure script was discovered
	if not _adapter_scripts.has(adapter_name):
		push_warning(
			"AdapterRegistry: Instance '%s' was not discovered via adapter_folder"
			% adapter_name
		)

	_adapter_instances[adapter_name] = adapter



# -----------------------------
# Discovery
# -----------------------------

func _discover_adapters() -> void:
	var dir := DirAccess.open(adapter_folder)
	if dir == null:
		push_error("AdapterRegistry: Could not open folder: %s" % adapter_folder)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".gd"):
			_try_register_script(adapter_folder + "/" + file_name)
		file_name = dir.get_next()

	dir.list_dir_end()

# -----------------------------
# Registration
# -----------------------------

func _try_register_script(path: String) -> void:
	var script := load(path)
	if script == null:
		return

	# Only consider scripts that ultimately extend BaseAdapter
	if not _script_extends_base_adapter(script):
		return

	# Never register BaseAdapter itself (treat it as abstract)
	if script == BaseAdapter:
		return

	# Godot 4: class_name lookup (this is the adapter identity)
	var adapter_name : String = script.get_global_name()
	if adapter_name == "":
		push_error("AdapterRegistry: Adapter at %s must declare a class_name" % path)
		return

	if _adapter_scripts.has(adapter_name):
		push_error("AdapterRegistry: Duplicate adapter name '%s' detected at %s" % [adapter_name, path])
		return

	_adapter_scripts[adapter_name] = script

func _script_extends_base_adapter(script: Script) -> bool:
	var current: Script = script
	while current != null:
		if current == BaseAdapter:
			return true
		current = current.get_base_script()
	return false
