extends GutTest

func test_core_setup_in_10_lines():
	# Can a user get the core working in minimal code?
	GlobalBusManager.reset()
	
	# 1. Create bus
	var game_bus = BaseEventBus.new()
	GlobalBusManager.register_bus("game", game_bus)
	
	# 2. Create simple adapter
	var test_adapter = SenderAdapter.new()
	test_adapter.listen_to_bus_named("game")
	
	# 3. Emit event
	game_bus.emit_event({"type": "test", "data": "hello"})
	
	# 4. Verify
	assert_eq(test_adapter["error_count"],0)
