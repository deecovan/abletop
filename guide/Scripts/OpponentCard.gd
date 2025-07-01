extends Node2D

var attack: int
var defence: int
var value: float = 0.0

func _ready() -> void:
	$AnimationPlayer.play("RESET")
