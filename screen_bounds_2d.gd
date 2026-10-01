class_name ScreenBounds2D
extends Node

@export var target: Node2D
@export var horizontal_margin: float = 16.0


func _ready() -> void:
	if not target:
		target = get_parent() as Node2D


func _physics_process(_delta: float) -> void:
	if not target:
		return

	var viewport := get_viewport()
	var visible_rect := viewport.get_visible_rect()
	var canvas_transform := viewport.get_canvas_transform()
	var screen_position := canvas_transform * target.global_position
	var min_x := visible_rect.position.x + horizontal_margin
	var max_x := visible_rect.end.x - horizontal_margin

	screen_position.x = clampf(screen_position.x, min_x, max_x)
	target.global_position = canvas_transform.affine_inverse() * screen_position
