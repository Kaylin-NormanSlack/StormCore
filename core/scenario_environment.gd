extends Node
class_name ScenarioEnvironment

var bus : BaseEventBus
var manager : BusManager
var adapters : Array = []
var emitted_events : Array = []

func build():
	_reset_state()
	_build_bus()
	_discover_adapters()
	_hook_event_capture()
	_initialize_adapters()

	return self


# --------------------------------------------------------------
#   Internal Steps
# --------------------------------------------------------------

func _reset_state():
	emitted_events.clear()


func _build_bus():
	bus = BaseEventBus.new()
	manager = BusManager.new(bus)


func _discover_adapters():
	var adapters = GlobalAdapterRegistry.get_all()


func _hook_event_capture():
	# Capture all events coming through the bus
	bus.event_emitted.connect(_on_event_emitted)


func _initialize_adapters():
	for adapter in adapters:
		if adapter.has_method("initialize"):
			adapter.initialize()


# --------------------------------------------------------------
#   Runtime Helpers
# --------------------------------------------------------------

func run_event(event_data: Dictionary):
	# Route through BusManager so adapters react naturally
	manager.route_event(event_data)


func get_emitted_events() -> Array:
	return emitted_events


func clear_emitted_events():
	emitted_events.clear()


# --------------------------------------------------------------
#   Signals
# --------------------------------------------------------------

func _on_event_emitted(event: Dictionary):
	# Store every event for the scenario runner
	emitted_events.append(event)
