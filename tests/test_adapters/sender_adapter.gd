extends BaseAdapter
class_name SenderAdapter

var last_sent: String = ""
var error_count: int = 0

func get_adapter_name() -> String:
	return "sender_adapter"

func get_category() -> String:
	return "example"

func get_supported_events() -> Array[String]:
	return ["send_message"]


func handle_event(event: Dictionary) -> void:
	if event.get("type", "") == "send_message":
		if event.has("payload"):
			var msg: String = event.get("payload", "")
			last_sent = msg

			if bus != null:
				bus.emit_event({
					"type": "message_sent",
					"payload": msg
				})
		else:
			error_count += 1
			if bus != null:
				bus.emit_event({
					"type": "error_occurred",
					"error_code": "MISSING_PAYLOAD"
				})

func get_final_state() -> Dictionary:
	return { "last_sent": last_sent, "error_count": error_count }
