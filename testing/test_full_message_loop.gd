extends GutTest

func test_full_message_loop():
	# Create a bus
	var bus = BaseEventBus.new()
	
	# Create an adapter and attach it to the bus
	var adapter = FakeAdapter.new()
	adapter.listen_to(bus)
	
	# Create a fake plugin and attach it to the adapter
	var plugin = FakePlugin.new()
	plugin.set_adapter(adapter)
	
	# Trigger the plugin's action
	plugin.do_something()
	
	await get_tree().process_frame
	
	assert_eq(adapter.recieved.size(),1)
	
	var event = adapter.recieved[0]
	
	assert_eq(event["name"], "plugin_event")
	assert_eq(event["payload"]["value"],42)
