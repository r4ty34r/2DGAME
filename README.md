# 2D Arena Shooter Game

## Project Overview
This project is a 2D arena-style shooter game where the player controls a character with movement mechanics similar to a 2D vehicle. The objective is to survive enemy attacks, ending when the player's health reaches zero or a high score of 20 reached. The game includes a simple restart mechanic after game over.

## Features
- **Arena-Style Combat:** Players face off against enemies in an arena.
- **Player Movement:** The player moves like a 2D vehicle, with simple movement controls.
- **Enemy Spawning:** Enemies spawn based on a timer.
- **Game Over:** The game ends when the player's health reaches zero, or when they reach a high score, followed by showing a restart option.
- **Restart Mechanism:** The game can be restarted by clicking a button after the player loses.
- **HTTP REQUEST:** While running a flask api in separate terminal, game logs username and score and sends to api.
  - Must have python installed, execute analytics_api.py in separate terminal to receive http get request on main.tscn ready and http post request on main2.gd game_over()

## Scene Structure
- **ControlUI (CanvasLayer):** The starting scene. Upon input, it transitions to the main scene.
- **Main (main.tscn):** The main gameplay scene where the player and enemies are instantiated. A timer node controls enemy spawning.
- **GameOver (CanvasLayer):** Displays a "Game Over" label and a restart button. The button triggers the `restart_game` function in `main.gd`, which redirects to the `ControlUI` scene.


## Getting Started
1. Clone this repository to your local machine.
2. Open the project in Godot Engine.
3. Start running the flask api with python in a separate terminal window.
4. Run the game and follow the on-screen instructions to start playing.
