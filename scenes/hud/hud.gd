extends CanvasLayer

signal start_game
signal player_ready

const TITLE = "Sucks to Suck"
const END_TITLE = "I'm sure you suck at other stuff"

func game_over():
	# Display a game over message
	$Root/EndLabel.text = TITLE
	$Root/ScoreLabel.hide()
	$Root/EndLabel.show()
	await get_tree().create_timer(1.5).timeout
	$Root/StartButton.show()
	
func end_game():
	# Display a game over message
	$Root/EndLabel.text = END_TITLE
	$Root/ScoreLabel.hide()
	$Root/EndLabel.show()
	await get_tree().create_timer(1.5).timeout
	$Root/StartButton.show()
	$Root/EndLabel.text = TITLE

func _on_start_button_pressed():
	$Root/StartButton.hide()
	$Root/EndLabel.hide()
	
	# Display a start game message
	#$Root/ReadyLabel.show()
	
	player_ready.emit()
	
	#await get_tree().create_timer(1.5).timeout
	
	#$Root/ReadyLabel.hide()
	
	$Root/ScoreLabel.show()
	


func hit(lives: int):
	$Root/ScoreLabel.text = str(lives)
	
func level_complete():
	$Root/EndLabel.text = "I guess you don't suck"
	$Root/EndLabel.show()
	await get_tree().create_timer(1.5).timeout
	
func level_start(n: int, name: String):
	$Root/LevelNumberLabel.text = str(n)
	$Root/EndLabel.text = name 
	
	$Root/EndLabel.show()
	$Root/LevelNumberLabel.show()
	await get_tree().create_timer(2.5).timeout
	$Root/EndLabel.hide()
	$Root/LevelNumberLabel.hide()
	
	start_game.emit()
