extends Node
class_name Movement

@export var speed: float = 100.0

func move_node(node: Node2D, direction: Vector2, delta: float) -> void:
	var normalized_direction := direction.normalized()
	if node is CharacterBody2D:
		var body := node as CharacterBody2D
		body.velocity = normalized_direction * speed
		body.move_and_slide()
	else:
		node.position += normalized_direction * speed * delta

func stop_node(node: Node2D) -> void:
	if node is CharacterBody2D:
		var body := node as CharacterBody2D
		body.velocity = Vector2.ZERO
		body.move_and_slide()