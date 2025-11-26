class_name BaseEventBus
extends RefCounted

signal event_emitted(name, payload)

func emit_event(name: String, payload: Dictionary = {}):
	emit_signal("event_emitted", name, payload)

func connect_listener(target: Object, method: String):
	connect("event_emitted",Callable(target,method))
