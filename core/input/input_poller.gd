extends Node

@export var bus_name: String = "game"
var bus: BaseEventBus = null
@export var bus_name: String = "InputBus"

var _was_pressed: Dictionary = {} # action -> bool

func initialize() -> void:
	GlobalBusManager.bus_registered.connect(_on_bus_registered)
	if GlobalBusManager.has_bus(bus_name):
		bus = GlobalBusManager.get_bus(bus_name)

func _process(_delta):
	if bus == null:
		print("[InputPoller] bus is null")
		return

		var prev: bool = _was_pressed.get(action, false)

		if pressed == prev:
			continue

		_was_pressed[action] = pressed
		
		bus.emit_event({
			"type": "input_pressed" if pressed else "input_released",
			"action": action
		})

func _on_bus_registered(name: String, registered_bus: BaseEventBus) -> void:
	if name == bus_name:
		bus = registered_bus
