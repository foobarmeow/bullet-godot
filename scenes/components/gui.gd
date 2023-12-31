extends Control

var paused: bool = false
var live_bus: String = "A"
var dead_bus: String = "B"


func _ready():
	$AnimationPlayer.play("fade_in_music")
	SignalBus.player_ready.connect(func():
		$HeartContainer.show()  
	)
	SignalBus.dead_title.connect(func():
		$ContinueContainer.show()
		$ContinueContainer/AnimationPlayer.play_backwards("fade_title")
	)
	SignalBus.weapon_get.connect(func():
		$WeaponGetContainer.show()
		$WeaponGetContainer/WeaponContainer/AnimationPlayer.play("weapon_get")
		$WeaponGetContainer/WeaponContainer/AnimationPlayer.animation_finished.connect(func(_a):
			await get_tree().create_timer(.5).timeout
			$WeaponGetContainer/WeaponContainer/AnimationPlayer.play_backwards("weapon_get")
			$WeaponGetContainer/WeaponContainer/AnimationPlayer.animation_finished.connect(func(_a):
				SignalBus.gui_done.emit()
			, CONNECT_ONE_SHOT)
		, CONNECT_ONE_SHOT)
	)
	SignalBus.change_music.connect(handle_music_change)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("action_input"):
		SignalBus.level_action.emit()
		return
	if Input.is_action_just_pressed("pause"):
		if paused:
			paused = false
			get_tree().paused = false
			$PauseContainer.hide()
		else:
			paused = true
			get_tree().paused = true
			$PauseContainer.show()
		return

func _on_damage_manager_health_updated(_health: int, _init_health: int):
	if !$HeartContainer:
		return

	var hearts = $HeartContainer.get_children()
	for i in hearts.size():
		var h = hearts[-i-1]
		if h.visible:
			h.hide()
			return
		
func _on_display_blood_hell():
	$PentagramContainer.visible = !$PentagramContainer.visible


func _on_start_button_pressed():
	$TitleContainer/AnimationPlayer.play("fade_title")
	SignalBus.start_pressed.emit()
	SignalBus.change_music.emit(1)

func _on_continue_button_pressed():
	$ContinueContainer/AnimationPlayer.play("fade_title")
	SignalBus.continue_pressed.emit()

	for h in $HeartContainer.get_children():
		h.show()

func handle_music_change(track_index: int):
	var track_name = "bs_title_%s" % track_index
	switch_track("res://music/%s.wav" % track_name)
	track_index += 1

func switch_track(track_path: String):
	# Find the dead streamer
	var dead_streamer = get_node("./Audio%s" % dead_bus)

	# Load the new track into the dead streamer
	# Fade them
	var track = load(track_path)
	dead_streamer.stream = track
	dead_streamer.play()
	fade()

func fade():
	var t = get_tree().create_tween()
	t.set_parallel(true)
	t.tween_method(change_audio_bus_volume.bind(dead_bus), -80, 0, 1.5)
	t.tween_method(change_audio_bus_volume.bind(live_bus), 0, -80, 1.5)

	var last_live_bus = live_bus
	live_bus = dead_bus
	dead_bus = last_live_bus

func change_audio_bus_volume(value: float, bus_name: String):
	var index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(index, value)
