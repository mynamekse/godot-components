# FollowTargetMovement2D.gd
class_name FollowTargetMovement2D
extends Node

enum AxisLock { NONE, LOCK_X, LOCK_Y }

@export var is_enabled: bool = true
@export var axis_lock: AxisLock = AxisLock.LOCK_Y
@export_range(1.0, 50.0, 0.5) var smooth_speed: float = 12.0
@export var snap_threshold: float = 1.0

var target_position: Vector2 = Vector2.ZERO

@export var parent: Node2D


func _ready() -> void:
	if not parent:
		parent = get_parent() as Node2D

	if parent:
		target_position = parent.global_position


func _physics_process(delta: float) -> void:
	if not is_enabled or not parent:
		return

	# 1. คำนวณพิกัดเป้าหมายตามเงื่อนไขการล็อกแกน
	var goal := target_position
	match axis_lock:
		AxisLock.LOCK_Y:
			goal.y = parent.global_position.y
		AxisLock.LOCK_X:
			goal.x = parent.global_position.x

	# 2. ถ้าเข้าใกล้เป้าหมายมากแล้ว ให้ Snap นิ่ง เพื่อหยุดการขยับยิบๆ (Jitter)
	if parent.global_position.distance_to(goal) < snap_threshold:
		parent.global_position = goal
		return

	# 3. Smooth Lerp ตาม Frame Rate (Time-independent Lerp)
	# เมื่อเข้าใกล้ mouse ค่า delta_distance จะลดลง ทำให้ยานชะลอความเร็วลงอัตโนมัติ
	var weight: float = 1.0 - exp(-smooth_speed * delta)
	parent.global_position = parent.global_position.lerp(goal, weight)
