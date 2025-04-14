extends Node2D

#@onready var enemy_scene: PackedScene = preload("res://enemy.tscn")
#commented out above to implement previous player node as enemy 
@onready var enemy_scene: PackedScene = preload("res://scenes/player.tscn")
@export var spawn_interval: float = 3.0  # Time between spawns
@export var spawn_radius: float = 100.0  # Distance from the player to spawn enemies
@onready var scoreLabel = $ScoreLabel
@onready var player: Node2D = get_tree().get_first_node_in_group("players")
@onready var game_over_screen = $GameOver
@onready var restart_button = $GameOver/GameOverLabel/RestartButton
@onready var game_over_camera = $GameOverCamera
@onready var httpnode = $HTTP

var score: int = 0
var scene_start_time: int = 0

func _ready():
	scene_start_time = Time.get_ticks_msec()

	#print("\nmain2.gd: calling testapi on http node")
	httpnode.test_api()
	#print("GameOver hidden in _ready()")
	#restart_button.hide()
	game_over_screen.hide()
	#game_over_camera.hide()
	#restart_button.hide()
	#game_over_screen.hide()
	game_over_camera.enabled = false

	if player:
		$EnemySpawnTimer.wait_time = spawn_interval
		$EnemySpawnTimer.start()

func _on_EnemySpawnTimer_timeout():
	if player:  # Ensure player still exists
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)

	# Spawn enemy at a random position around the player
	var angle = randf() * TAU  # Random angle in radians
	var spawn_position = player.global_position + Vector2.RIGHT.rotated(angle) * spawn_radius
		
	# Clamp the spawn position to stay within playable area (0,0 to 1100,500)
	spawn_position.x = clamp(spawn_position.x, 0, 1100)
	spawn_position.y = clamp(spawn_position.y, 0, 500)

	enemy.global_position = spawn_position

func updateScore():
	score += 1
	PlayerData.user_score+=1
	var update: String = "Current Score: "+ String.num(score)
	scoreLabel.text = update
	#print("\nmain2.gd: score updated... PlayerData.score is: ", PlayerData.user_score)
	
	# win condition
	if score == 20:
		print("\nhigh score reached")
		game_over()


func game_over():
	var time_taken = get_scene_runtime_string()
	print("Level completed in: ", time_taken)
	
	PlayerData.accuracy = PlayerData.shots_landed / PlayerData.shots_fired
	print("\nShooting accuracy is: ", PlayerData.accuracy)
	game_over_screen.show()
	scoreLabel.text = "Final Score: "+ String.num(score)
	#implement the http request here 
	# send player data inside http reuqest 
	print("animated_player.gd: Sending http post request\n")
	PlayerData.send_flag = true # used to control process node in httpscript
	
	
	
	if $GameOver.visible:
		#print("\nGame Over UI should be visible: ", $GameOver.visible)
		#print("\nbutton should be up ")
		get_tree().paused = true  # Pause the game
		#print("\ngame paused")
		#recenter camera on restart section
		if game_over_camera:
			game_over_camera.enabled = true  # Activate backup camera
			game_over_camera.make_current()

			game_over_camera.global_position = restart_button.global_position  # Recenter on button

func restart_game():
	#print("\nunpausing game")
	get_tree().paused = false  # Unpause
	#print("\nreloading scene")
	#get_tree().reload_current_scene()  # Reload the level
	get_tree().change_scene_to_file("res://scenes/control_ui.tscn")

func _on_restart_button_pressed() -> void:
	#print("\nrestart button pressed\n")
	restart_game()

func get_scene_runtime_string() -> String:
	var elapsed = Time.get_ticks_msec() - scene_start_time
	var total_seconds = int(elapsed / 1000)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	return "%d:%02d:%02d" % [hours, minutes, seconds]
