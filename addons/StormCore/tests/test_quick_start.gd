extends GutTest

var test_root: Node


func before_each() -> void:
	test_root = Node.new()
	test_root.name = "NodeTestRoot"
	add_child(test_root)
	
	for adapter in GlobalAdapterRegistry.get_all():
		if adapter.get_parent() == null:
			test_root.add_child(adapter)

# This is here to clean up orphaned nodes created by the test.
func after_each():
	if is_instance_valid(test_root):
		test_root.free()
	
	GlobalAdapterRegistry._clear_state()	
	test_root = null

func test_core_setup_in_10_lines():
	InputPoller.is_enabled = false
	# Can a user get the core working in minimal code?
	GlobalBusManager.reset()
	
	# 1. Create bus
	var game_bus = BaseEventBus.new()
	GlobalBusManager.register_bus("GameBus", game_bus)
	
	# 2. Create simple adapter
	var test_adapter = add_child_autofree(SenderAdapter.new())
	test_adapter.listen_to_bus_named("GameBus")
	
	# 3. Emit event
	game_bus.emit_event({"type": "test", "data": "hello"})
	
	# 4. Verify
	assert_eq(test_adapter["error_count"],0)
