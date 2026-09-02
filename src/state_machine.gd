extends Node

@export var initial_state : BaseState

var current_state : BaseState

func init(parent: CharacterBody2D, animations: AnimatedSprite2D, move_component) -> void:
	for child in get_children():
		child.parent = parent
		child.animations = animations
		child.move_component = move_component
			
	change_state(initial_state)
	
func change_state(new_state: BaseState) -> void:	
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.enter()	
	
func process_physics(delta):
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
