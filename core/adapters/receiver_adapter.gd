extends BaseAdapter
class_name ReceiverAdapter

var last_received: String = ""

func _init():
	adapter_name = "receiver_adapter"
	adapter_category = "messaging"
	supported_events = ["message_sent"]


func initialize():
	last_received = ""


func handle_event(event: Dictionary) -> void:
	if event.get("type", "") == "message_sent":
		var msg := event.get("payload", "")
		last_received = msg

		bus.emit_event({
			"type": "message_received",
			"payload": msg
		})



func get_final_state() -> Dictionary:
	return {
		"last_received": last_received
	}

func set_bus(b: BaseEventBus) -> void:
	bus = b


func reset_for_test():
	last_received = ""
