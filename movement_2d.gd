# Movement2d.gd
class_name Movement2d
extends Node

enum AxisLock { NONE, LOCK_X, LOCK_Y }

@export var speed: float = 200.0
@export var is_enabled: bool = true
@export var axis_lock: AxisLock = AxisLock.NONE

var direction: Vector2 = Vector2.ZERO:
	set(value):
		if not is_enabled:
			direction = Vector2.ZERO
			return

		# จัดการ Lock แกน X หรือ Y
		match axis_lock:
			AxisLock.LOCK_X:
				direction = Vector2(0.0, value.y)
			AxisLock.LOCK_Y:
				direction = Vector2(value.x, 0.0)
			AxisLock.NONE:
				direction = value


func set_direction(value: Vector2) -> void:
	direction = value


@onready var target: Node2D = get_parent() as Node2D
var _move_handler: Callable


func _ready() -> void:
	if target is CharacterBody2D:
		_move_handler = _move_character_body.bind(target as CharacterBody2D)
	elif target is Area2D:
		_move_handler = _move_area.bind(target as Area2D)
	else:
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		_move_handler.call(delta)


func _move_character_body(delta: float, body: CharacterBody2D) -> void:
	body.velocity = direction * speed
	body.move_and_slide()


func _move_area(delta: float, area: Area2D) -> void:
	area.global_position += direction * speed * delta
