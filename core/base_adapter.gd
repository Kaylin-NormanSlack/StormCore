class_name BaseAdapter
extends RefCounted

var _busses: Array = []

func listen_to(bus: BaseEventBus):
	_busses.append(bus)
	bus.connect_listener(self,"_on_event")

func _on_event(event_name, payload):
	handle_event(event_name, payload)
	

func handle_event(event_name:String, payload : Dictionary):
	#Override this in child
	pass
