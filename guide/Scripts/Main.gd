extends Node2D

func _ready() -> void:
	Engine.max_fps = 30
	Engine.physics_ticks_per_second = 30

func _process(_delta):
	if Input.is_action_pressed('reload'):
		get_tree().reload_current_scene()
