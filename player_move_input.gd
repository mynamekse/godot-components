extends Node
class_name PlayerMoveInput

signal direction_changed(new_direction: Vector2)

@export var action_left: StringName = &"ui_left"
@export var action_right: StringName = &"ui_right"
@export var action_up: StringName = &"ui_up"
@export var action_down: StringName = &"ui_down"

var current_direction: Vector2 = Vector2.ZERO

func _unhandled_input(_event: InputEvent) -> void:
	var input_dir := Input.get_vector(action_left, action_right, action_up, action_down)
	
	if input_dir != current_direction:
		current_direction = input_dir
		direction_changed.emit(current_direction)
