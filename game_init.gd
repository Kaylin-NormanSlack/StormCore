extends Node


func _ready():
	# 1. Register core buses
	GlobalBusManager.register_bus("UIBus", BaseEventBus.new())
	GlobalBusManager.register_bus("GameBus", BaseEventBus.new())
	GlobalBusManager.register_bus("AudioBus", BaseEventBus.new())
	GlobalBusManager.register_bus("InputBus", BaseEventBus.new())

	
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
