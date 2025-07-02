extends Node2D

func _ready() -> void:
	Engine.max_fps = 0
	Engine.physics_ticks_per_second = 0
	RenderingServer.viewport_set_msaa_2d(Viewport, RenderingServer.VIEWPORT_MSAA_MAX)
	RenderingServer.viewport_set_screen_space_aa(Viewport, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_MAX)

func _process(_delta):
	if Input.is_action_pressed('reload'):
		get_tree().reload_current_scene()
