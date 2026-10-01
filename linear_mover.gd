class_name LinearMover
extends Node

@export var speed: float = 600.0
@export var auto_move: bool = true

var _target: Node2D


func _ready() -> void:
	_target = get_parent() as Node2D


func _physics_process(delta: float) -> void:
	if not auto_move or not _target:
		return

	var forward: Vector2 = Vector2.RIGHT.rotated(_target.global_rotation)
	_target.global_position += forward * speed * delta
