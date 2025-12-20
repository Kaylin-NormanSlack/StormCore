extends Node
class_name BaseAdapter

"""Responsibilities:
- Declare adapter identity (get_adapter_name)
- Declare supported events (optional)
- Listen to buses by NAME, not object
- Attach to bus when available
- Provide override hooks for subclasses
"""

# The bus this adapter is currently listening to (if any)
var bus: BaseEventBus = null

# Internal: which bus name this adapter is waiting for
var _listening_bus_name: String = ""

# Internal: prevent double connections
var _is_listening: bool = false


# ============================================================
# REQUIRED OVERRIDES (ENGINE CONTRACT)
# ============================================================


func get_adapter_name() -> String:
	return "base_adapter"

func get_category() -> String:
	return "generic"

func get_supported_events() -> Array[String]:
	return []

func handle_event(event: Dictionary) -> void:
	# Override in concrete adapters
	pass

func initialize() -> void:
	# Optional override for adapter setup
	pass


func on_bus_ready() -> void:
	"""
	Called exactly once when the named bus becomes available.
	Override this to connect signals.
	"""
	pass


func get_final_state() -> Dictionary:
	return {}
	
	
func listen_to_bus_named(bus_name: String) -> void:
	if bus_name == "":
		push_error("listen_to_bus_named called with empty bus name")
		return

	_listening_bus_name = bus_name

	# Case 1: Bus already exists
	if GlobalBusManager.has_bus(bus_name):
		attach_bus(GlobalBusManager.get_bus(bus_name))
		_is_listening = true
		return

	# Case 2: Bus will exist later
	if not _is_listening:
		GlobalBusManager.bus_registered.connect(_on_bus_registered)
		_is_listening = true


func _on_bus_registered(name: String, bus_obj: BaseEventBus) -> void:
	if name != _listening_bus_name:
		return

	attach_bus(bus_obj)

	# Stop listening once attached
	if GlobalBusManager.bus_registered.is_connected(_on_bus_registered):
		GlobalBusManager.bus_registered.disconnect(_on_bus_registered)

	_is_listening = false


func attach_bus(p_bus: BaseEventBus) -> void:
	bus = p_bus
	on_bus_ready()
