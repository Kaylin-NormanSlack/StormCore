extends BaseAdapter
class_name PhantomCameraAdapter

var _camera: PhantomCamera2D
var _host: Node


func initialize() -> void:
	self.name = "Phantom Camera Adapter"
	adapter_name = "Phantom Camera Adapter"
	preferred_bus_name = "CameraBus"
	listen_to_bus_named(preferred_bus_name)
	#_resolve_camera()


func get_adapter_name() -> String:
	return "PhantomCameraAdapter"


func get_category() -> String:
	return "camera"


func get_supported_events() -> Array[String]:
	return [
		"follow_target",
		"camera_priority",
		"camera_active",
	]


func _resolve_camera() -> void:
	_host = get_tree().root.find_child(
		"PhantomCameraHost",
		true,
		false
	)

	if _host == null:
		push_error("PhantomCameraHost not found.")
		return

	_camera = PhantomCamera2D.new()
	_host.add_child(_camera)


func handle_event(event: Dictionary) -> void:
	if _camera == null:
		return

	match event.get("type", ""):
		"follow_target":
			_handle_follow_target(event)

		"camera_priority":
			_handle_camera_priority(event)

		"camera_active":
			_handle_camera_active(event)


func _handle_follow_target(event: Dictionary) -> void:
	var target: Node = event.get("value")

	if target == null:
		var target_group := StringName(
			event.get("target_group", "")
		)

		if not target_group.is_empty():
			target = get_tree().get_first_node_in_group(target_group)

	if target == null:
		push_warning("Camera follow target could not be resolved.")
		return

	_camera.follow_target = target


func _handle_camera_lull(_event: Dictionary) -> void:
	pass


func _handle_camera_priority(event: Dictionary) -> void:
	var value = event.get("value")

	if value != null:
		_camera.priority = value


func _handle_camera_active(event: Dictionary) -> void:
	var value = event.get("value")

	if value != null:
		_camera.enabled = value
