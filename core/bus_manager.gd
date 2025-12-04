# res://core/bus_manager.gd
extends Node
class_name BusManager

var bus: BaseEventBus

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
