extends Node
class_name MovementComponent

## -----------------------------
## Configuration (Design / Rules)
## -----------------------------

@export var enabled: bool = true
@export var move_speed: float = 200.0

@export var look_at_mouse: bool = true

## -----------------------------
## Cached references
## -----------------------------

var _body: CharacterBody2D
var _input_bus: BaseEventBus

## -----------------------------
## Intent state (ephemeral)
## -----------------------------

var _move_axis: float = 0.0

## -----------------------------
## Lifecycle
## -----------------------------

func _ready() -> void:
	if not enabled:
		return

	_body = owner as CharacterBody2D
	if _body == null:
		push_warning("MovementComponent must be attached to a CharacterBody2D.")
		return

	if GlobalBusManager.has_bus("InputBus"):
		_input_bus = GlobalBusManager.get_bus("InputBus")
	else:
		GlobalBusManager.bus_registered.connect(_on_bus_registered)

	if _input_bus:
		_connect_signals()

func _exit_tree() -> void:
	if _input_bus and _input_bus.event_emitted.is_connected(_on_intent_event):
		_input_bus.event_emitted.disconnect(_on_intent_event)

## -----------------------------
## Bus resolution
## -----------------------------

func _on_bus_registered(name: String, bus: BaseEventBus) -> void:
	if name == "InputBus":
		_input_bus = bus
		_connect_signals()

## -----------------------------
## Signal wiring
## -----------------------------

func _connect_signals() -> void:
	if not _input_bus.event_emitted.is_connected(_on_intent_event):
		_input_bus.event_emitted.connect(_on_intent_event)

## -----------------------------
## Intent handling (semantic only)
## -----------------------------

func _on_intent_event(event: Dictionary) -> void:
	match event.get("type", ""):
		"move_axis":
			_move_axis = event.get("x", 0.0)
			_move_axis = event.get("y", 0.0)

## -----------------------------
## Physics loop (Mechanics)
## -----------------------------

func _physics_process(delta: float) -> void:
	if not enabled:
		return

	_apply_movement()

	_body.move_and_slide()

## -----------------------------
## Mechanics (single-purpose)
## -----------------------------

func _apply_movement() -> void:
	_body.velocity.x = _move_axis * move_speed
	_body.velocity.y = _move_axis * move_speed
