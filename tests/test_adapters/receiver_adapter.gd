# res://core/adapters/test_adapters/receiver_adapter.gd
extends BaseAdapter
class_name ReceiverAdapter

var last_received: String = ""

func get_adapter_name() -> String:
	return "receiver_adapter"

func get_category() -> String:
	return "example"

func get_supported_events() -> Array[String]:
	return ["message_sent"]


func handle_event(event: Dictionary) -> void:
	if event.get("type", "") == "message_sent":
		var msg: String = event.get("payload", "")
		last_received = msg

		if bus != null:
			bus.emit_event({
				"type": "message_received",
				"payload": msg
			})


func get_final_state() -> Dictionary:
	return { "last_received": last_received }
