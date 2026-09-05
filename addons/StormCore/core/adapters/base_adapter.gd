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

var adapter_name: String = "base_adapter"

var preferred_bus_name: String = ""

# Internal: which bus name this adapter is waiting for
var _listening_bus_name: String = ""

# Internal: prevent double connections
var _is_listening: bool = false


# ============================================================
# REQUIRED OVERRIDES (ENGINE CONTRACT)
# ============================================================


func get_adapter_name() -> String:
	return adapter_name

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
	print(
		"Adapter: ",
		get_adapter_name(),
		" trying to attach to bus ",
		bus_name
	)

	var found_bus = GlobalBusManager.get_bus(bus_name)

	print(
		"Adapter ",
		get_adapter_name(),
		" found bus: ",
		found_bus
	)

	if found_bus == null:
		print(
			"Adapter ",
			get_adapter_name(),
			" could not attach: bus not available yet"
		)
		return

	bus = found_bus

	if not bus.event_emitted.is_connected(handle_event):
		bus.event_emitted.connect(handle_event)

	print(
		"Adapter ",
		get_adapter_name(),
		" connected to ",
		bus_name
	)


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
