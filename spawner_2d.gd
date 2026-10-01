class_name Spawner2D
extends Node2D

signal spawned(entity: Node2D)

@export_group("Scene Setup")
@export var scene: PackedScene
@export var target_parent: Node

@export_group("Transform & Offset")
@export var offset_position: Vector2 = Vector2.ZERO
@export var random_radius: float = 0.0
@export var inherit_rotation: bool = true
@export_range(0.0, TAU, 0.01, "radians_as_degrees") var random_angle_range: float = 0.0

@export_group("Timing")
@export var auto_start: bool = false
@export var interval: float = 1.0
@export var interval_variance: float = 0.0
@export var max_count: int = 0

var _spawn_count: int = 0
var _timer: Timer


func _ready() -> void:
	if auto_start:
		_setup_timer()


func spawn() -> Node2D:
	if not scene or (max_count > 0 and _spawn_count >= max_count):
		return null

	var parent_node: Node = target_parent
	if not parent_node:
		parent_node = get_tree().current_scene
	if not parent_node:
		return null

	var instance := scene.instantiate() as Node2D
	if not instance:
		return null

	parent_node.add_child(instance)

	var final_position := global_position + offset_position
	if random_radius > 0.0:
		final_position += Vector2.RIGHT.rotated(randf() * TAU) * randf_range(0.0, random_radius)

	var final_rotation := global_rotation if inherit_rotation else 0.0
	if random_angle_range > 0.0:
		final_rotation += randf_range(-random_angle_range * 0.5, random_angle_range * 0.5)

	instance.global_position = final_position
	instance.global_rotation = final_rotation

	_spawn_count += 1
	spawned.emit(instance)
	return instance


func _setup_timer() -> void:
	_timer = Timer.new()
	_timer.one_shot = false
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	_start_next_interval()


func _start_next_interval() -> void:
	var next_time := maxf(0.01, interval + randf_range(-interval_variance, interval_variance))
	_timer.start(next_time)


func _on_timer_timeout() -> void:
	spawn()
	if max_count > 0 and _spawn_count >= max_count:
		_timer.stop()
	else:
		_start_next_interval()
