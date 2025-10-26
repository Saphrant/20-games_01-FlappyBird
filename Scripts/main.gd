extends Node2D

signal game_start

@onready var player: RigidBody2D = $Player
@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var obstacle_parent: Node2D = $ObstacleParent
@onready var main_menu: Node2D = $MainMenu
@onready var start_timer: Timer = $Timers/StartTimer

var obstacle_scene : PackedScene = preload("res://Scenes/obstacle.tscn")
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.button_start.connect(new_game)
	game_start.connect(player.on_game_start)
	#get_tree().paused = true
	
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
	start_timer.start()
	

func _on_spawn_timer_timeout() -> void:
	spawn_obstacle()
	spawn_timer.wait_time = randf_range(0.5,1.2)
	
	
func _on_start_timer_timeout() -> void:
	spawn_timer.start()
	game_start.emit()
	

func _on_button_press() -> void:
	new_game()
