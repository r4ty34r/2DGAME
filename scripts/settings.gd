extends Node

enum Difficulty { EASY, REGULAR, IMPOSSIBLE }

var difficulty: Difficulty = Difficulty.EASY


# settings to be used to load in to the main scene, changes based on option selected 

# defaulted to regular values
var playerDamageSetting: int = 10 # param to adjust is damageAmount in animated_player.gd, controls how much damage a player takes from enemy bullet
var healthTimer: float = 2.0 # param to adjust is powerup_spawn_timer in main2.gd

var powerupHealhAmt: int = 25 # controls how much health is added to player 

var enemyDamageSetting: float = 25.0 # controls how much damage a single player bullet does to an enemy



func set_difficulty(new_difficulty: Difficulty):
	difficulty = new_difficulty
	match difficulty:
		Difficulty.EASY:
			playerDamageSetting = 5
			healthTimer = 5.0
			powerupHealhAmt = 10
			enemyDamageSetting = 15.0

		Difficulty.REGULAR:
			playerDamageSetting = 10
			healthTimer = 2.0
			powerupHealhAmt = 25
			enemyDamageSetting = 25.0

		Difficulty.IMPOSSIBLE:
			playerDamageSetting = 30
			healthTimer = 1.5
			powerupHealhAmt = 35
			enemyDamageSetting = 40.0
