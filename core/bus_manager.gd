extends Node
class_name BusManager

var bus: BaseEventBus

func _init(b: BaseEventBus = null):
	bus = b


func register_adapter(adapter: BaseAdapter) -> void:
	# Inject the bus into each adapter so they can emit events.
	adapter.bus = bus


func route_event(event: Dictionary) -> void:
	# Determine the event type.
	var type: String = event.get("type", "")
	if type == "":
		push_warning("BusManager: Event missing 'type' field: %s" % str(event))
		return

	# Get all adapters that should receive this event.
	var receivers: Array = GlobalAdapterRegistry.get_receivers_for_event(type)

	for adapter in receivers:
		if adapter.has_method("handle_event"):
			adapter.handle_event(event)
		else:
			push_warning("BusManager: Adapter '%s' has no handle_event()" % adapter.adapter_name)
