extends Node

func build_test_environment():
	var bus = BaseEventBus.new()
	var manager = BusManager.new(bus)

	var adapters = AdapterRegistry.get_adapters()
	for a in adapters:
		a.initialize()
		manager.register_adapter(a)

	return manager
