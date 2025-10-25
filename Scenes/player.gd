extends RigidBody2D

@export var fall_acceleration := 75
@export var tap_force := 500

var target_velocity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Tap"):
		apply_central_impulse(Vector2(0,-tap_force))
		print(linear_velocity)
	
	if 	linear_velocity < Vector2(0,-500):
		linear_velocity += Vector2(0,100)
