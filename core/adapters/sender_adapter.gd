extends BaseAdapter
class_name SenderAdapter

var last_sent: String = ""

func get_adapter_name() -> String:
	return "sender_adapter"

func get_supported_events() -> Array:
	return ["send_message"]

func get_category() -> String:
	return "messaging"

func handle_event(event: Dictionary) -> void:
	if event.get("type", "") == "send_message":
		var msg := event.get("payload", "")
		last_sent = msg

		bus.emit_event({
			"type": "message_sent",
			"payload": msg
		})
