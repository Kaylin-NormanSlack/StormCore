extends Node

var buses:= {}

func register_bus(bus_name:String, bus_ref:BaseEventBus):
	buses[bus_name] = bus_ref
	
func get_bus(bus_name:String) -> BaseEventBus:
	return buses.get(bus_name)
