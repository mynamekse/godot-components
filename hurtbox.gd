class_name Hurtbox
extends Area2D

signal damage_received(amount: float, source: Node)

@export var damage_receiver: Node
@export var is_enabled: bool = true


func _ready() -> void:
	if not damage_receiver:
		damage_receiver = get_parent()

	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func apply_damage(amount: float, source: Node = null) -> void:
	if not is_enabled or amount <= 0.0:
		return

	damage_received.emit(amount, source)
	if damage_receiver and damage_receiver.has_method("take_damage"):
		damage_receiver.call("take_damage", amount)


func _on_area_entered(area: Area2D) -> void:
	_handle_hit_source(area)


func _on_body_entered(body: Node2D) -> void:
	_handle_hit_source(body)


func _handle_hit_source(source: Node) -> void:
	var damage := _read_damage(source)
	if damage > 0.0:
		apply_damage(damage, source)


func _read_damage(source: Object) -> float:
	for property_info in source.get_property_list():
		if property_info.name == "damage":
			var value: Variant = source.get("damage")
			if typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT:
				return float(value)

	return 0.0
