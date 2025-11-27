extends Node
class_name BaseEventBus

signal event_emitted(event: Dictionary)

func emit_event(event: Dictionary) -> void:
	emit_signal("event_emitted", event)

func connect_listener(target: Object, method: String):
	connect("event_emitted",Callable(target,method))
