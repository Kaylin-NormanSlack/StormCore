extends Node


func _ready():
	# 1. Register core buses
	GlobalBusManager.register_bus("ui", BaseEventBus.new())
	GlobalBusManager.register_bus("game", BaseEventBus.new())
	GlobalBusManager.register_bus("audio", BaseEventBus.new())
	
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
