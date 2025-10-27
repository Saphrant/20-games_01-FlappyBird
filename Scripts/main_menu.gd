extends Node2D

signal button_start
signal music_mute(mute:bool)

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var current_texture = 0
func _ready() -> void:
	canvas_layer.visible = true

func _on_button_pressed() -> void:
	canvas_layer.visible = false
	button_start.emit()
	$"../ButtonClick".play()


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	var texture:=[
		preload("res://Assets/musicOn.png"),
		preload("res://Assets/musicOff.png"),
	]
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if current_texture == 0:
				$CanvasLayer/TextureRect.texture = texture[1]
				current_texture = 1
				music_mute.emit(true)
			elif current_texture == 1:
				$CanvasLayer/TextureRect.texture = texture[0]
				current_texture = 0
				music_mute.emit(false)
