extends Node2D

const MAX_FPS = 100

func _ready() -> void:
	Engine.max_fps = MAX_FPS
	Engine.physics_ticks_per_second = MAX_FPS

func _process(_delta):
	if Input.is_action_pressed('reload'):
		get_tree().reload_current_scene()
