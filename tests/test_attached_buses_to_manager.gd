extends GutTest

func test_attached_buses_to_manager():
	InputPoller.is_enabled = false
	# Can a user get the core working in minimal code?
	GlobalBusManager.reset()
	
	# 1. Create bus
	var test_bus = BaseEventBus.new()
	GlobalBusManager.register_bus("TestBus", test_bus)
	GlobalBusManager.attach_bus(test_bus)
	
	# 4. Verify
	assert_eq(GlobalBusManager.get_child_count(),1)
	assert_eq(GlobalBusManager.get_child(0),test_bus)
	
