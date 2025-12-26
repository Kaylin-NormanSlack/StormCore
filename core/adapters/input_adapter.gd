extends BaseAdapter
class_name InputAdapter


func initialize():
	listen_to_bus_named("game")

func get_adapter_name() -> String:
	return "input_adapter"

func get_supported_events() -> Array[String]:
	return ["input_pressed", "input_released"]


func handle_event(event: Dictionary) -> void:
	match event.get("type", ""):
		"input_pressed":
			print(event.get("action") + " Pressed!")

		"input_released":
			print(event.get("action") + " Released!")
			pass
