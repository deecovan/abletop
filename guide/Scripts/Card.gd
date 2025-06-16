extends Node2D

signal hovered
signal hovered_off

func _ready() -> void:
	pass

func _on_hovered() -> void:
	emit_signal("hovered", self)

func _on_hovered_off() -> void:
	emit_signal("hovered_off", self)
