extends BaseAdapter

## StormCore adapter for Maaack's SceneLoader autoload.
##
## Responsibilities:
## - Listen to SceneBus
## - Translate StormCore scene events into SceneLoader calls
## - Keep Maaack-specific code outside the rest of StormCore


func _init() -> void:
	self.name = "Scene Load Adapter"
	adapter_name = "Scene Load Adapter"
	preferred_bus_name = "SceneBus"
	print(
		"Adapter: ",
		get_adapter_name(),
		" trying to attach to bus ",
		preferred_bus_name
	)
	listen_to_bus_named(preferred_bus_name)
	print(
		"Adapter ",
		get_adapter_name(),
		" found bus: ",
		bus
	)
	print(
		"Adapter ",
		get_adapter_name(),
		" connected to ",
		preferred_bus_name
	)
	

	
	

func get_category() -> String:
	return "scene"


func get_supported_events() -> Array[String]:
	return [
		"load_scene",
		"reload_scene"
	]


func handle_event(event: Dictionary) -> void:
	print("SCENE ADAPTER LOAD SIGNAL RECIEVED")
	var event_name: String = event.get("event", "")

	match event_name:
		"load_scene":
			_handle_load_scene(event)

		"reload_scene":
			_handle_reload_scene()

		_:
			push_warning(
				"SceneLoaderAdapter received unsupported event: %s"
				% event_name
			)


func _handle_load_scene(event: Dictionary) -> void:
	var payload: Dictionary = event.get("payload", {})
	var scene_path: String = payload.get("scene_path", "")
	var in_background: bool = payload.get("in_background", false)

	if scene_path.is_empty():
		push_error(
			"SceneLoaderAdapter: load_scene requires payload.scene_path"
		)
		return

	SceneLoader.load_scene(scene_path, in_background)


func _handle_reload_scene() -> void:
	SceneLoader.reload_current_scene()
