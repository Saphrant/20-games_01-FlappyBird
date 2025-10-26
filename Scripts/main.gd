extends Node2D

@onready var player: RigidBody2D = $Player
@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var obstacle_parent: Node2D = $ObstacleParent

var obstacle_scene : PackedScene = preload("res://Scenes/obstacle.tscn")
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_obstacle_score_up(amount: int) -> void:
	score += amount
	print("New score: ", score)
	#$HUD/ScoreLabel.text = str(score)

func spawn_obstacle() -> void:
	var obstacle = obstacle_scene.instantiate()
	obstacle.score_up.connect(_on_obstacle_score_up)
	var obstacle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	obstacle_spawn_location.progress_ratio = randf()
	obstacle.position = obstacle_spawn_location.position

	obstacle_parent.add_child(obstacle)
	
	
func game_over() -> void:
	spawn_timer.stop()

func new_game() -> void:
	score = 0
	$Timers/StartTimer.start()
	

func _on_spawn_timer_timeout() -> void:
	spawn_obstacle()
	spawn_timer.wait_time = randf_range(0.5,1.2)
	
	
	
func _on_start_timer_timeout() -> void:
	spawn_timer.start()
