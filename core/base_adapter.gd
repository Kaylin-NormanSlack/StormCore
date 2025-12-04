# res://core/base_adapter.gd
extends Node
class_name BaseAdapter

var bus: BaseEventBus

func get_adapter_name() -> String:
	return "base_adapter"

func get_category() -> String:
	return "generic"

func get_supported_events() -> Array[String]:
	return []

func handle_event(event: Dictionary) -> void:
	# Override in concrete adapters
	pass

func get_final_state() -> Dictionary:
	return {}
