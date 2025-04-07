extends Node
# Analytics data
var shots_fired: int = 0
var damage_dealt: float = 0
var enemies_killed: int = 0
var user_name: String
var user_score: int = enemies_killed
var user_deaths: int = 0

var send_flag: bool = false

func _ready():
	print("\nplayer data script loaded")
