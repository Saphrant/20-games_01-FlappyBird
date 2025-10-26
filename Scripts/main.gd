extends Node2D

signal game_start

@onready var player: RigidBody2D = $Player
@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var obstacle_parent: Node2D = $ObstacleParent
@onready var main_menu: Node2D = $MainMenu
@onready var start_timer: Timer = $Timers/StartTimer
@onready var score_label: Label = $UI/Score/ScoreLabel
@onready var get_ready_label: Label = $UI/Score/GetReady
@onready var game_over_label: Label = $UI/Score/GameOver
@onready var countdown_label: Label = $UI/Score/Countdown


var obstacle_scene : PackedScene = preload("res://Scenes/obstacle.tscn")
var score : int = 0
var is_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.button_start.connect(new_game)
	game_start.connect(player.on_game_start)
	score_label.visible = false
	get_ready_label.visible = true
	countdown_label.visible = true
	game_over_label.visible = false

func _process(_delta: float) -> void:
	if not is_started:
		_countdown()

func _on_obstacle_score_up(amount: int) -> void:
	score += amount
	print("New score: ", score)
	score_label.text = "%d" % score

func spawn_obstacle() -> void:
	var obstacle = obstacle_scene.instantiate()
	obstacle.score_up.connect(_on_obstacle_score_up)
	var obstacle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	obstacle_spawn_location.progress_ratio = randf()
	obstacle.position = obstacle_spawn_location.position

	obstacle_parent.add_child(obstacle)
	
	
func game_over() -> void:
	spawn_timer.stop()
	game_over_label.visible = true

func new_game() -> void:
	score = 0
	start_timer.start()
	

func _on_spawn_timer_timeout() -> void:
	spawn_obstacle()
	spawn_timer.wait_time = randf_range(0.8,1.2)
	
	
func _on_start_timer_timeout() -> void:
	spawn_obstacle()
	spawn_timer.start()
	get_ready_label.visible = false
	countdown_label.visible = false
	score_label.visible = true
	is_started = true
	game_start.emit()
	

func _on_button_press() -> void:
	new_game()

func _countdown() -> void:
	countdown_label.text = "%d" % start_timer.time_left
