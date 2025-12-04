extends Node
class_name BaseEventBus

signal event_emitted(event: Dictionary)

func emit_event(event: Dictionary) -> void:
	# Single point for all events.
	emit_signal("event_emitted", event)
