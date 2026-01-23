extends Node
class_name BusManager

signal bus_registered(bus_name: String, bus: BaseEventBus)
signal buses_ready
signal stormcore_ready
var _ready_emitted : bool = false

var bus: BaseEventBus = null
var _buses: Dictionary = {}

func _ready() -> void:
	self.add_to_group("bus_manager")


func register_bus(bus_name: String, bus: Node) -> void:
	if _buses.has(bus_name):
		push_warning("Bus already registered: %s" % bus_name)
		return

	bus.name = bus_name
	add_child(bus) # THIS is what makes it non-orphaned
	_buses[bus_name] = bus

func attach_bus(p_bus: BaseEventBus) -> void:
	bus = p_bus
	if bus != null and not bus.event_emitted.is_connected(_on_bus_event):
		bus.event_emitted.connect(_on_bus_event)


func _on_bus_event(event: Dictionary) -> void:
	# Every event that hits the bus goes through here.
	route_event(event)


func route_event(event: Dictionary) -> void:
	var type: String = event.get("type", "")
	if type == "":
		push_warning("BusManager: Event missing 'type' field: %s" % str(event))
		return

	# Ask registry who should receive this type.
	var receivers: Array = GlobalAdapterRegistry.get_receivers_for_event(type)

	for adapter in receivers:
		var a: BaseAdapter = adapter
		if a.has_method("handle_event"):
			a.handle_event(event)
		else:
			push_warning("BusManager: Adapter '%s' has no handle_event()" % a.get_adapter_name())

func has_bus(name: String) -> bool:
	return _buses.has(name)

func get_bus(name: String) -> BaseEventBus:
	return _buses.get(name, null)

func reset() -> void:
	_buses.clear()
