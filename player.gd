extends CharacterBody2D

@onready
var player_move_component = $MoveComponent

func _ready() -> void:
	pass


func _process(delta):
	pass

func _unhandled_input(event: InputEvent) -> void:
	pass
func _physics_process(delta: float) -> void:
	pass

func _fixed_process(delta: float) -> void:
	pass

func _on_death_area_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene() 		
