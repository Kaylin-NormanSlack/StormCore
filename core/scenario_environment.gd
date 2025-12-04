# res://core/scenario_environment.gd
extends Node
class_name ScenarioEnvironment

var bus: BaseEventBus
var manager: BusManager
var adapters: Array = []
var emitted_events: Array[Dictionary] = []


func build() -> void:
	_reset_state()

	# 1. Create ONE bus instance
	bus = BaseEventBus.new()

	# 2. Create ONE manager instance and attach the SAME bus
	manager = BusManager.new()
	manager.attach_bus(bus)

	# 3. Discover adapters
	adapters = GlobalAdapterRegistry.get_all()

	# 4. Connect environment to bus (SAME ONE)
	bus.event_emitted.connect(_on_event_emitted)

	# 5. Give EVERY adapter the SAME bus instance
	for a in adapters:
		a.bus = bus
		if a.has_method("initialize"):
			a.initialize()


func _reset_state() -> void:
	emitted_events.clear()
	bus = null
	manager = null
	adapters.clear()


func _hook_event_capture() -> void:
	if bus != null and not bus.event_emitted.is_connected(_on_event_emitted):
		bus.event_emitted.connect(_on_event_emitted)


func _on_event_emitted(event: Dictionary) -> void:
	emitted_events.append(event)


func _initialize_adapters() -> void:
	for a in adapters:
		a.bus = bus   # every adapter gets the SAME bus
		if a.has_method("initialize"):
			a.initialize()


func run_event(event_data: Dictionary) -> void:
	# TOP-LEVEL INPUT → BUS, not manager.
	if bus != null:
		bus.emit_event(event_data)


func get_emitted_events() -> Array:
	return emitted_events.duplicate()


func clear_emitted_events() -> void:
	emitted_events.clear()


func reset() -> void:
	emitted_events.clear()
	# If you later add stateful adapters, you can optionally reset them here.
