extends Node
class_name BaseState

@export
var animation_name: String
@export
var move_speed: float = 400

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var animations: AnimatedSprite2D
var move_component
var parent: CharacterBody2D

func enter() -> void:
	animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> BaseState:
	return null

func process_frame(delta: float) -> BaseState:
	return null

func process_physics(delta: float) -> BaseState:
	return null

func get_movement_input() -> float:
	return move_component.get_movement_direction()

func get_jump() -> bool:
	return move_component.wants_jump()
