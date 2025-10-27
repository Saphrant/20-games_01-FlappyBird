extends RigidBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var gravity := get_gravity() 

@export var tap_force := 600

var tap_vector := Vector2(0,-tap_force)
var is_started : bool
func _ready() -> void:
	anim_player.play("idle")


func _physics_process(_delta: float) -> void:
	if not is_started:
		gravity_scale = 0
		return
	if Input.is_action_just_pressed("Tap"):
		linear_velocity.y = 0
		apply_central_impulse(tap_vector)
		var tween = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "rotation", -0.5,0.1)
		tween.tween_property(animated_sprite_2d, "rotation", 0.7,0.5)	
		cpu_particles_2d.emitting = true		
	else:
		linear_velocity += gravity

func on_game_start() -> void:
	anim_player.stop()
	is_started = true
	var tween = create_tween()
	tween.tween_property(self,"gravity_scale", 2.0, 0.5).set_ease(Tween.EASE_OUT)

func on_game_over() -> void:
	is_started = false
