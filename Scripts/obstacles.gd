extends Node2D

signal score_up(amount)

@onready var rock_up: Sprite2D = $Bottom/RockUp
@onready var rock_texture:=[
	preload("res://Assets/PNG/rock.png"),
	preload("res://Assets/PNG/rockGrass.png"),
	preload("res://Assets/PNG/rockSnow.png"),
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rock_up.texture = rock_texture.pick_random()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= 200 * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_score_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		score_up.emit(1)
