extends RigidBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

@onready var gravity := get_gravity() 

@export var tap_force := 500

var tap_vector := Vector2(0,-tap_force)

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Tap"):
		linear_velocity.y = 0
		apply_central_impulse(tap_vector)
		var tween = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "rotation", -0.5,0.1)
		tween.tween_property(animated_sprite_2d, "rotation", 0.7,0.5)	
		cpu_particles_2d.emitting = true		
	else:
		linear_velocity += gravity


func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.
