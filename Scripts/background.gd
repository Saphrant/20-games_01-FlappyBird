extends Node2D

@onready var background_clouds: Parallax2D = $BackgroundClouds
@onready var ground_rocks: Parallax2D = $GroundRocks
@onready var ground_dirt: Parallax2D = $GroundDirt

@export var scroll_speed := 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	background_clouds.autoscroll = Vector2(-scroll_speed, 0)
	ground_dirt.autoscroll = Vector2(-scroll_speed*10, 0)
	ground_rocks.autoscroll = Vector2(-scroll_speed*6, 0)
