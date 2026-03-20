extends CanvasLayer

@onready var _main_buttons: VBoxContainer = $CenterContainer/MainButtons
@onready var _settings_menu: VBoxContainer = $CenterContainer/SettingsMenu
# gdlint: disable=max-line-length
@onready
var _main_volume_slider: HSlider = $CenterContainer/SettingsMenu/MainVolumeContainer/MainVolumeSlider
@onready
var _sound_effects_volume_slider: HSlider = $CenterContainer/SettingsMenu/SoundEffectsVolumeContainer/SoundEffectsVolumeSlider
@onready
var _music_volume_slider: HSlider = $CenterContainer/SettingsMenu/MusicVolumeContainer/MusicVolumeSlider
# gdlint: enable=max-line-length


func _input(_event: InputEvent) -> void:
	if MainMenu.visible:
		return

	if Input.is_action_just_pressed("pause"):
		if visible:
			get_tree().paused = false
			var sound_effect_config: SoundEffectConfig = _get_unpause_sound_effect_config()
			SoundEffectManager.play_effect(sound_effect_config)
		else:
			get_tree().paused = true
			var sound_effect_config: SoundEffectConfig = _get_pause_sound_effect_config()
			SoundEffectManager.play_effect(sound_effect_config)

		visible = !visible


func _ready() -> void:
	visible = false
	MainMenu.started.connect(_set_volume_sliders)


func _set_volume_sliders() -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	_main_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))

	var sound_effects_bus_index: int = AudioServer.get_bus_index("SoundEffects")
	_sound_effects_volume_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(sound_effects_bus_index)
	)

	var music_bus_index: int = AudioServer.get_bus_index("Music")
	_music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))


func _get_pause_sound_effect_config() -> SoundEffectConfig:
	return load("res://menus/sound_effects/pause.tres")


func _get_unpause_sound_effect_config() -> SoundEffectConfig:
	return load("res://menus/sound_effects/unpause.tres")


func _get_button_hover_sound_effect_config() -> SoundEffectConfig:
	return load("res://menus/sound_effects/button_hover.tres")


func _get_button_click_sound_effect_config() -> SoundEffectConfig:
	return load("res://menus/sound_effects/button_click.tres")


func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false

	var sound_effect_config: SoundEffectConfig = _get_unpause_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)


func _on_settings_button_pressed() -> void:
	_main_buttons.visible = false
	_settings_menu.visible = true

	var sound_effect_config: SoundEffectConfig = _get_button_click_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)


func _on_quit_button_pressed() -> void:
	get_tree().quit()

	var sound_effect_config: SoundEffectConfig = _get_button_click_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)


func _on_back_button_pressed() -> void:
	_main_buttons.visible = true
	_settings_menu.visible = false

	var sound_effect_config: SoundEffectConfig = _get_button_click_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)


func _on_main_volume_slider_value_changed(value: float) -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(master_bus_index, value)


func _on_sound_effects_volume_slider_value_changed(value: float) -> void:
	var sound_effects_bus_index: int = AudioServer.get_bus_index("SoundEffects")
	AudioServer.set_bus_volume_linear(sound_effects_bus_index, value)


func _on_music_volume_slider_value_changed(value: float) -> void:
	var music_bus_index: int = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(music_bus_index, value)


func _on_button_hover() -> void:
	var sound_effect_config: SoundEffectConfig = _get_button_hover_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)


func _on_normal_button_click() -> void:
	var sound_effect_config: SoundEffectConfig = _get_button_click_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)
