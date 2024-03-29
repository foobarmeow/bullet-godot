extends Control

@export var skip_gui: bool = false

var paused: bool = false
var live_bus: String = "A"
var dead_bus: String = "B"

var music_muted: bool = false
var sound_muted: bool = false

func _ready():
	SignalBus.game_end.connect(func():
		$AnimationPlayer.play("end")
	)
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
	$AnimationPlayer.play('fade_in_game')
	if skip_gui:
		_skip_gui()
	$AnimationPlayer.animation_finished.connect(func(_a):
		$TitleContainer/StartButton.disabled = false
		$TitleContainer/StartButton.visible = true
	, CONNECT_ONE_SHOT)


func _skip_gui():
	await get_tree().create_timer(1).timeout
	_on_start_button_pressed()
	$DevSplash.visible = false
	$BGSprite.visible = false
	$TitleContainer/StartButton.disabled = false
	$TitleContainer/StartButton.visible = true

var debug_music_track = 0
func _unhandled_input(_event):
	if Input.is_action_just_pressed("blood_hell"):
		debug_music_track += 1
		if debug_music_track > 5:
			debug_music_track = 0
		SignalBus.change_music.emit(debug_music_track)
		return
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
	$StartPlayer.play()
	$TitleContainer/AnimationPlayer.play("fade_title")
	SignalBus.start_pressed.emit()
	SignalBus.change_music.emit(1)

func _on_continue_button_pressed():
	$StartPlayer.play()
	$ContinueContainer/AnimationPlayer.play("fade_title")
	SignalBus.continue_pressed.emit()

	for h in $HeartContainer.get_children():
		h.show()

func _on_fun_part_pressed():
	$StartPlayer.play()
	$AnimationPlayer.play("fun_part")
	SignalBus.fun_part.emit()

	for h in $HeartContainer.get_children():
		h.show()


func handle_music_change(track_index: int):
	var track_name = "bs_title_%s" % track_index
	switch_track("res://music/%s.wav" % track_name)

func switch_track(track_path: String):
	# Find the dead streamer
	var dead_streamer = get_node("./Audio%s" % dead_bus)

	# Load the new track into the dead streamer
	# Fade them
	var track = load(track_path)
	dead_streamer.stream = track
	dead_streamer.play()
	fade(dead_bus == 'B')

func fade(a_to_b: bool):
	if a_to_b:
		$AudioAnimator.play("fade_a_to_b")
		dead_bus = "A"
	else:
		$AudioAnimator.play("fade_b_to_a")
		dead_bus = "B"


func change_audio_bus_volume(value: float, bus_name: String):
	var index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(index, value)


func _on_sound_effects_toggle_pressed():
	var index = AudioServer.get_bus_index('SoundEffects')
	AudioServer.set_bus_mute(index, !sound_muted)
	sound_muted = !sound_muted


func _on_music_toggle_pressed():
	var index = AudioServer.get_bus_index('Music')
	AudioServer.set_bus_mute(index, !music_muted)
	music_muted = !music_muted
