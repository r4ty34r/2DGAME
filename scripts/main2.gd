extends Node2D

#@onready var enemy_scene: PackedScene = preload("res://enemy.tscn")
#commented out above to implement previous player node as enemy 
@onready var enemy_scene: PackedScene = preload("res://scenes/player.tscn")
@export var spawn_interval: float = 3.0  # Time between enemy spawns
@export var spawn_radius: float = 100.0  # Distance from the player to spawn enemies
@onready var scoreLabel = $ScoreLabel
@onready var player: Node2D = get_tree().get_first_node_in_group("players")
@onready var game_over_screen = $GameOver
@onready var restart_button = $GameOver/GameOverLabel/RestartButton
@onready var game_over_camera = $GameOverCamera
@onready var httpnode = $HTTP
var score: int = 0
var scene_start_time: int = 0
@export var health_powerup_scene: PackedScene = preload("res://scenes/health_power_up.tscn")
@export var powerup_spawn_timer = Settings.healthTimer    #2.0  # Seconds between spawns
var elapsed_time 

func _ready():
	# Print a more readable string representation
	match Settings.difficulty:
		Settings.Difficulty.EASY:
			print("Game starting on Easy difficulty")
		Settings.Difficulty.REGULAR:
			print("Game starting on Regular difficulty")
		Settings.Difficulty.IMPOSSIBLE:
			print("Game starting on Impossible difficulty")
	 # Create a global audio player
	var music_player = AudioStreamPlayer.new()
	music_player.stream = preload("res://music/ELECTROSYNTH.mp3")
	#music_player.autoplay = true    
	# Add it to the scene tree
	add_child(music_player)
	music_player.play()
	
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
		$PowerUpTimer.wait_time = powerup_spawn_timer
		$PowerUpTimer.start()

func _process(delta):
	#print("\nmain2.gd: player position is: ", player.position)
	# Track elapsed time
	elapsed_time = (Time.get_ticks_msec() - scene_start_time) / 1000.0  # Convert to seconds
	# Every 20 seconds, decrease spawn interval (increase spawn rate)
	if int(elapsed_time) % 20 == 0 and elapsed_time > 0:  # Check if 20 seconds have passed
		spawn_interval = max(spawn_interval - 0.01, 0.06)  # Decrease and spawn more, but don't go below 0.06
		#print("New spawn interval: ", spawn_interval)
		$EnemySpawnTimer.wait_time = spawn_interval  # Update the spawn timer's wait time

func _on_EnemySpawnTimer_timeout():
	if player:  # Ensure player still exists
		spawn_enemy2()

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

func spawn_enemy2():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	var spawn_position = get_random_point_in_area($Floor/SpawnZone)
	enemy.global_position = spawn_position

func updateScore():
	score += 1
	PlayerData.user_score+=1
	var update: String = "Current Score: "+ str(score)
	scoreLabel.text = update
	#print("\nmain2.gd: score updated... PlayerData.score is: ", PlayerData.user_score)
	# win condition
	if score == 20:
		print("\nhigh score reached")
		game_over()


func game_over():
	var time_taken = get_scene_runtime_string()
	#print("main2.gd: Level completed in: ", time_taken)
	PlayerData.session_time = time_taken
	#print("\nmain2.gd: Shots fired is: ", PlayerData.shots_fired)
	#print("\nmain2.gd: Shots landed is: ", PlayerData.shots_landed)
	PlayerData.accuracy = snapped(float(PlayerData.shots_landed) / PlayerData.shots_fired, 0.01)
	#PlayerData.accuracy = float(PlayerData.shots_landed) / float(PlayerData.shots_fired)
	#print("\nmain2.gd: formatted Shooting accuracy is: %.2f" % PlayerData.accuracy)
	#print("\nmain2.gd: Damage dealt iS: ", PlayerData.damage_dealt)
	game_over_screen.show()
	scoreLabel.text = "Final Score: "+ str(PlayerData.user_score)
	#implement the http request here 
	# send player data inside http reuqest 
	print("main2.gd: animated_player.gd: Sending http post request\n")
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


func spawn_health_powerup():
	var powerup = health_powerup_scene.instantiate()
	add_child(powerup)
	var spawn_position = get_random_point_in_area($Floor/SpawnZone)
	powerup.global_position = spawn_position

func _on_power_up_timer_timeout() -> void:
	if player.health < 60:
		spawn_health_powerup() # commented out  to test health bar animation
		#print("power up spawn")
# function to control random spawning of power ups and enemies
func get_random_point_in_area(area: Area2D) -> Vector2:
	# Get the collision polygon
	var polygon_node = area.get_node_or_null("CollisionPolygon2D")
	if not polygon_node:
		push_error("No CollisionPolygon2D found in area")
		return area.global_position
	
	# Get the polygon points
	var polygon = polygon_node.polygon
	if polygon.size() < 3:
		push_error("Polygon has less than 3 points")
		return area.global_position

	# Triangulate the polygon
	var triangles = Geometry2D.triangulate_polygon(polygon)
	if triangles.size() == 0:
		push_error("Failed to triangulate polygon")
		return area.global_position

	# Calculate the areas of triangles for weighted selection
	var triangle_areas = []
	var total_area = 0.0

	for i in range(0, triangles.size(), 3):
		var p1 = polygon[triangles[i]]
		var p2 = polygon[triangles[i+1]]
		var p3 = polygon[triangles[i+2]]

		# Calculate triangle area using cross product
		var triarea = abs((p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)) / 2.0)
		triangle_areas.append(triarea)
		total_area += triarea

	# Select random triangle (weighted by area)
	var rand_val = randf() * total_area
	var current_area = 0.0
	var selected_triangle = 0

	for i in range(triangle_areas.size()):
		current_area += triangle_areas[i]
		if rand_val <= current_area:
			selected_triangle = i
			break

	# Get the vertices of the selected triangle
	var idx = selected_triangle * 3
	var p1 = polygon[triangles[idx]]
	var p2 = polygon[triangles[idx+1]]
	var p3 = polygon[triangles[idx+2]]

	# Generate a random point using barycentric coordinates
	# This ensures uniform distribution within the triangle
	var r1 = sqrt(randf())
	var r2 = randf()
	var a = 1.0 - r1
	var b = r1 * (1.0 - r2)
	var c = r1 * r2
	var point = a * p1 + b * p2 + c * p3
	# Convert to global coordinates
	return area.to_global(point)
