extends CanvasLayer

var main_menu_scene = load("res://scenes/canvas_and_ui/main_menu_scene.tscn")
@onready var game_timer = $game_timer
var elapsed_time: int = 0

func toggle_pause(is_game_over = false):
	get_tree().paused = !get_tree().paused
	if get_tree().paused and !is_game_over:
		$game_paused_panel.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif is_game_over:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		$game_paused_panel.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func _on_unpause_button_pressed():
	toggle_pause()

func _on_main_menu_button_pressed():
	get_tree().paused = !get_tree().paused
	Global.main_menu()

func game_over(reason: String):
	toggle_pause(true)
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time % 60)
	%game_over_label.text = reason + "\n Game is over"
	%game_info_label.text = "Time: %02d" % minutes + ":" + "%02d" % seconds
	var storms = Global.overall_storms_survived + Global.this_zone_storms_survived
	var s = " storms"
	if storms == 1:
		s = " storm"
	%game_info_label.text +=  "\n" + str(storms) + s + " survived"
	
	$game_over_panel.show()

func _on_game_timer_timeout():
	elapsed_time += 1


func _on_exit_button_pressed():
	get_tree().quit()

func _on_restart_button_pressed():
	toggle_pause()
	Global.restart()
