extends BaseAdapter
class_name TestListenerAdapter

var bus_ready_called := false

func on_bus_ready():
	bus_ready_called = true
