extends PanelContainer

onready var fps_label = $VBoxContainer/FPS
onready var draw_calls_label = $VBoxContainer/DrawCalls
onready var time_process = $VBoxContainer/TimeProcess
onready var time_physics_process = $VBoxContainer/TimePhysicsProcess

func _process(delta):
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	draw_calls_label.text = "Draw calls: " + str(Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME))
	time_process.text = "Time frame: " + str(Performance.get_monitor(Performance.TIME_PROCESS))
	time_physics_process.text = "Physics frame: " + str(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS))
