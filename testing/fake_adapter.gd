class_name FakeAdapter
extends BaseAdapter

var recieved = []

func handle_event(name, payload):
	recieved.append({"name": name,"payload": payload})
	
