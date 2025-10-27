extends Node2D

signal game_start
signal game_over

#---- UI ----
@onready var countdown_label: Label = $UI/GameStart/Countdown
@onready var score_label: Label = $UI/Score/ScoreLabel
@onready var game_start_UI: Control = $UI/GameStart
@onready var game_over_UI: Control = $UI/GameOver
@onready var share: Control = $UI/Share
@onready var share_score: Label = $UI/Share/MarginContainer/MarginContainer2/VBoxContainer/Score
@onready var high_score_label: Label = $UI/GameOver/VBoxContainer/VBoxContainer/HighScore
@onready var current_score_label: Label = $UI/GameOver/VBoxContainer/VBoxContainer2/CurrentScore

#---- Setup ----
@onready var background: Node2D = $Background
@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var main_menu: Node2D = $MainMenu
@onready var start_timer: Timer = $Timers/StartTimer

#---- References ----
@onready var obstacle_parent: Node2D = $ObstacleParent
@onready var player_scene : PackedScene = preload("res://Scenes/player.tscn")
@onready var player = player_scene.instantiate()
@onready var player_start_pos: Marker2D = $PlayerStartPos

var obstacle_scene : PackedScene = preload("res://Scenes/obstacle.tscn")

var is_started: bool = false
var current_score: int = 0
var high_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	high_score = load_game()
	player.global_position = player_start_pos.global_position
	add_child(player)
	main_menu.button_start.connect(_new_game)
	game_start.connect(player.on_game_start)
	game_over.connect(player.on_game_over)
	background.player_crash.connect(on_player_crash)
	score_label.visible = false
	game_start_UI.visible = true
	game_over_UI.visible = false
	share.visible = false
	get_tree().paused = false

func _process(_delta: float) -> void:
	if not is_started:
		_countdown()

func _on_obstacle_score_up(amount: int) -> void:
	current_score += amount
	score_label.text = "%d" % current_score

func spawn_obstacle() -> void:
	var obstacle = obstacle_scene.instantiate()
	obstacle.score_up.connect(_on_obstacle_score_up)
	obstacle.player_crash.connect(on_player_crash)
	var obstacle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	obstacle_spawn_location.progress_ratio = randf()
	obstacle.position = obstacle_spawn_location.position

	obstacle_parent.add_child(obstacle)
	
	
func _game_over() -> void:
	spawn_timer.stop()
	game_over_UI.visible = true
	score_label.visible = false
	is_started = false
	get_tree().paused = true
	share_score.text = "%s" % current_score
	current_score_label.text = "%s" % current_score
	if current_score > high_score:
		high_score_label.text = "%s" % current_score
	else:
		high_score_label.text = "%s" % high_score
		
	check_and_save_high_score()


func _restart_game() -> void:
	player = player_scene.instantiate()
	player.global_position = player_start_pos.global_position
	add_child(player)
	get_tree().paused = false
	for i in obstacle_parent.get_children():
		i.queue_free()
	game_over_UI.visible = false
	score_label.visible = true
	current_score = 0
	score_label.text = "%s" % current_score
	spawn_obstacle()
	spawn_timer.start()
	game_start.connect(player.on_game_start)
	game_start.emit()
	

func _new_game() -> void:
	get_tree().paused = false
	score_label.visible = true
	current_score = 0
	start_timer.start()
	

func _on_spawn_timer_timeout() -> void:
	spawn_obstacle()
	spawn_timer.wait_time = randf_range(0.8,1.2)
	
	
func _on_start_timer_timeout() -> void:
	spawn_obstacle()
	spawn_timer.start()
	game_start_UI.visible = false
	countdown_label.visible = false
	score_label.visible = true
	is_started = true
	game_start.emit()
	

func _on_button_press() -> void:
	_new_game()

func _countdown() -> void:
	countdown_label.text = "%d" % start_timer.time_left

func on_player_crash() -> void:
	_game_over()
	game_over.emit()


func _on_restart_pressed() -> void:
	var player_node = get_tree().get_first_node_in_group("player")
	player_node.queue_free()
	_restart_game()


func _on_share_pressed() -> void:
	share.visible = true
	

func _on_bg_click_eater_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and share.visible:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			share.visible = false


# Saves the score you pass to it
func save_game(score_to_save: int) -> void:
	# Open the file for writing
	var save_file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	# Check if the file opened successfully
	if save_file:
		save_file.store_var(score_to_save)
		save_file.close()


# Loads the high score and returns it
func load_game() -> int:
	# Check if the save file exists first
	if not FileAccess.file_exists("user://high_score.save"):
		return 0 # No save file, so the high score is 0
		
	# Open the file for reading
	var save_file = FileAccess.open("user://high_score.save", FileAccess.READ)
	
	if save_file:
		var loaded_score = save_file.get_var()
		save_file.close()
		if loaded_score is int:
			return loaded_score
			
	# Fallback in case of an error
	return 0


func check_and_save_high_score() -> void:
	if current_score > high_score:
		high_score = current_score
		save_game(high_score)
