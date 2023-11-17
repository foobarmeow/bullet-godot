extends CanvasLayer

signal start_game

func end_game():
	# Display a game over message
	$Root/ScoreLabel.hide()
	$Root/EndLabel.show()
	await get_tree().create_timer(1.5).timeout
	$Root/StartButton.show()

func _on_start_button_pressed():
	$Root/StartButton.hide()
	$Root/EndLabel.hide()
	
	# Display a start game message
	$Root/ReadyLabel.show()
	await get_tree().create_timer(1.5).timeout
	$Root/ReadyLabel.hide()
	$Root/ScoreLabel.show()
	
	start_game.emit()

func hit(lives: int):
	$Root/ScoreLabel.text = str(lives)
	
