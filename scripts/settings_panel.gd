extends PanelContainer

@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sf_bus = AudioServer.get_bus_index("SF")

func _ready():
	$VBoxContainer/music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	$VBoxContainer/SF_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sf_bus))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_sf_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sf_bus, linear_to_db(value))
