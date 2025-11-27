extends Node
class_name ScenarioEnvironment

var bus: BaseEventBus
var manager: BusManager
var adapters: Array = []
var _captured_events: Array = []


# ================================================================
# PUBLIC API
# ================================================================

func build() -> void:
	"""
	Builds a fresh environment:
	- Creates a new EventBus
	- Creates a new BusManager
	- Retrieves adapters from GlobalAdapterRegistry
	- Registers adapters with the manager
	- Hooks event capture
	- Initializes adapters
	"""
	_reset_state()

	bus = BaseEventBus.new()
	manager = BusManager.new(bus)

	adapters = GlobalAdapterRegistry.get_all()

	_hook_event_capture()
	_register_adapters()
	_initialize_adapters()


func reset() -> void:
	"""
	Resets event capture and optional adapter state.
	This does NOT rebuild the bus or re-discover adapters,
	because ScenarioRunner will reuse the same environment.
	"""
	_captured_events.clear()

	# Optional: adapters may define a reset.
	for a in adapters:
		if a.has_method("reset_for_test"):
			a.reset_for_test()


func run_event(event_data: Dictionary) -> void:
	"""
	Routes an input event into the BusManager.
	"""
	manager.route_event(event_data)


func get_emitted_events() -> Array:
	return _captured_events


func clear_emitted_events() -> void:
	_captured_events.clear()


# ================================================================
# INTERNAL LOGIC
# ================================================================

func _reset_state() -> void:
	bus = null
	manager = null
	adapters = []
	_captured_events.clear()


func _register_adapters() -> void:
	for a in adapters:
		manager.register_adapter(a)


func _initialize_adapters() -> void:
	for a in adapters:
		if a.has_method("initialize"):
			a.initialize()


func _hook_event_capture() -> void:
	# Connect to the bus so every event emitted by adapters is captured.
	if bus.has_signal("event_emitted"):
		bus.event_emitted.connect(_on_event_emitted)
	else:
		push_warning("ScenarioEnvironment: EventBus missing 'event_emitted' signal.")


# ================================================================
# SIGNAL HANDLERS
# ================================================================

func _on_event_emitted(ev: Dictionary) -> void:
	"""
	EventBus will emit this signal whenever an adapter emits an event.
	We simply store it so ScenarioRunner can validate it later.
	"""
	_captured_events.append(ev)
