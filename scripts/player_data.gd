extends Node
# Analytics data
var shots_fired: int = 0
var shots_landed: int = 0
var shots_missed: int = shots_fired - shots_landed
var damage_dealt: float = 0
var enemies_killed: int = 0
var user_name: String
var user_score: int = enemies_killed
var user_deaths: int = 0
var accuracy: float = 0
var session_seconds: float = 0.0 # this is in seconds , divide by 60 for mins
var send_flag: bool = false
var scene_start_time: int = 0
var session_time: String
func _ready():
	print("\nplayer data script loaded")

#
#var dataBundle = {
		#"player_id": user_name,
		#"session_time": 69420,
		#"score": PlayerData.enemies_killed,
		#"deaths": 420,
		#"Level": 69
	#}

#format of the api data is
	#player_id (username)
	#session_time
	#score
	#deaths
	#level
	#accuracy
	#damage
