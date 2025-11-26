class_name FakePlugin
extends RefCounted

var adapter: BaseAdapter

func set_adapter(a):
	adapter = a

func do_something():
	adapter.handle_event("plugin_event", {"value": 42})
