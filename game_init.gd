extends Node
func _ready():
	# 1. Register core buses
	GlobalBusManager.register_bus("ui", BaseEventBus.new())
	GlobalBusManager.register_bus("game", BaseEventBus.new())
	GlobalBusManager.register_bus("audio", BaseEventBus.new())
	
	# 2. Load game adapters (auto-discovered)
	GlobalAdapterRegistry.adapter_folder = "res://game/adapters/"
	GlobalAdapterRegistry.reload()
	
	# 3. Connect adapters to buses
	var adapters = GlobalAdapterRegistry.get_all()
	for adapter in adapters:
		var bus_name = adapter.get_bus_preference()  # New method maybe?
		if bus_name:
			adapter.listen_to_bus_named(bus_name)
	
	# 4. Start the game
	GlobalBusManager.get_bus("game").emit_event({
		"type": "game_start",
		"level": 1
	})
