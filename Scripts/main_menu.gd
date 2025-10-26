extends Node2D

signal button_start

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	canvas_layer.visible = true

func _on_button_pressed() -> void:
	canvas_layer.visible = false
	button_start.emit()
