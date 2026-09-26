extends Node
class_name Movement

@export var speed: float = 200.0
## โหนดเป้าหมายที่ต้องการขยับ (ถ้าเว้นว่างไว้ จะใช้ Parent อัตโนมัติ)
@export var target: Node2D

var _current_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	if target == null and get_parent() is Node2D:
		target = get_parent() as Node2D

func _physics_process(delta: float) -> void:
	if target == null:
		return

	if target is CharacterBody2D:
		var body := target as CharacterBody2D
		body.velocity = _current_direction * speed
		body.move_and_slide()
	else:
		target.position += _current_direction * speed * delta

# ==========================================
# Methods สำหรับรับการเชื่อมต่อ (Signal / Code)
# ==========================================

## รับทิศทางเวกเตอร์ (ใช้ต่อตรงกับ signal direction_changed ได้ทันที)
func set_direction(direction: Vector2) -> void:
	_current_direction = direction.normalized()

## สั่งเคลื่อนที่ด้วยเวกเตอร์
func move(direction: Vector2) -> void:
	set_direction(direction)

## สั่งหยุดเดิน
func stop() -> void:
	set_direction(Vector2.ZERO)