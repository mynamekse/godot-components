class_name PlayerInputMove2d
extends Node

signal move_input(direction: Vector2)

var _last_direction: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != _last_direction:
		_last_direction = direction
		move_input.emit(direction)
