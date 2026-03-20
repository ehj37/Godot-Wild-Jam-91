extends Control

signal started

@onready var _main_menu_buttons: VBoxContainer = $CenterContainer/MainMenuButtons
@onready var _settings_menu: VBoxContainer = $CenterContainer/SettingsMenu
# gdlint: disable=max-line-length
@onready
var _main_volume_slider: HSlider = $CenterContainer/SettingsMenu/MainVolumeContainer/MainVolumeSlider
@onready
var _sound_effects_volume_slider: HSlider = $CenterContainer/SettingsMenu/SoundEffectsVolumeContainer/SoundEffectsVolumeSlider
@onready
var _music_volume_slider: HSlider = $CenterContainer/SettingsMenu/MusicVolumeContainer/MusicVolumeSlider
# gdlint: enable=max-line-length


func _ready() -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	_main_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))

	var sound_effects_bus_index: int = AudioServer.get_bus_index("SoundEffects")
	_sound_effects_volume_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(sound_effects_bus_index)
	)

	var music_bus_index: int = AudioServer.get_bus_index("Music")
	_music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))


func _get_button_hover_sound_effect_config() -> SoundEffectConfig:
	return load("res://menus/sound_effects/button_hover.tres")


func _get_button_click_sound_effect_config() -> SoundEffectConfig:
	return load("res://menus/sound_effects/button_click.tres")


func _get_start_click_sound_effect_config() -> SoundEffectConfig:
	return load("res://menus/sound_effects/start_click.tres")


func _on_start_button_pressed() -> void:
	_main_menu_buttons.visible = false

	var sound_effect_config: SoundEffectConfig = _get_start_click_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)

	visible = false
	started.emit()


func _on_settings_button_pressed() -> void:
	_main_menu_buttons.visible = false
	_settings_menu.visible = true

	var sound_effect_config: SoundEffectConfig = _get_button_click_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)


func _on_credits_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()

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


func _on_back_button_pressed() -> void:
	_main_menu_buttons.visible = true
	_settings_menu.visible = false

	var sound_effect_config: SoundEffectConfig = _get_button_click_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)


func _on_button_hover() -> void:
	var sound_effect_config: SoundEffectConfig = _get_button_hover_sound_effect_config()
	SoundEffectManager.play_effect(sound_effect_config)
