extends Node


func _ready():
	# 1. Register core buses
	GlobalBusManager.register_bus("UIBus", BaseEventBus.new())
	GlobalBusManager.register_bus("GameBus", BaseEventBus.new())
	GlobalBusManager.register_bus("AudioBus", BaseEventBus.new())
	GlobalBusManager.register_bus("InputBus", BaseEventBus.new())
	GlobalBusManager.register_bus("CameraBus", BaseEventBus.new())
	GlobalBusManager.register_bus("SceneBus", BaseEventBus.new())

	
	# 2. Load game adapters (auto-discovered)
	#GlobalAdapterRegistry.adapter_folder = "res://game/adapters/"
	GlobalAdapterRegistry.reload()
	InputPoller.initialize()
	
	# 3. Connect adapters to buses
	var adapters = GlobalAdapterRegistry.get_all()
	for adapter in adapters:
		adapter.initialize()
		var bus_name = adapter.preferred_bus_name
		if bus_name:
			adapter.listen_to_bus_named(bus_name)
	_request_opening_scene()

func _request_opening_scene() -> void:
	var scene_bus := GlobalBusManager.get_bus("SceneBus")

	if not scene_bus is BaseEventBus:
		push_error("StormRoot could not resolve SceneBus.")
		return

	scene_bus.emit_event({
		"event": "load_scene",
		"payload": {
			"scene_path": "res://scenes/opening/opening.tscn"
		}
	})
