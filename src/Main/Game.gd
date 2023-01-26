extends Node
# This class contains controls that should always be accessible, like pausing
# the game or toggling the window full-screen.


# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var _pause_menu = $InterfaceLayer/PauseMenu



func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()

func _ready():#QW
	if name == "Splitscreen":#QW check is splitscreen and wether show player2 lives bar
		$InterfaceLayer/InGameUI.changeToSplitScreen()#QW
	else:#QW
		$InterfaceLayer/InGameUI.changeToGameScreen()#QW
		

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		# We need to clean up a little bit first to avoid Viewport errors.
		if name == "Splitscreen":
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()

func updateCoin():#QW update the total coins on the UI
	$InterfaceLayer/InGameUI.showCoin($InterfaceLayer/PauseMenu/ColorRect/CoinsCounter.getCoinAmount())#QW

func _process(delta):#QW
	updateCoin()#QW update

func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	# The desired behavior is when pausing is to pause the gamplay,
	# but the Pause Menu should continue to process.
	# To achieve this, the "Pause Mode" field is used on nodes in the Game scene:
	# 1. The root node in the Game scene is set to process even when the game is paused
	#   (via Pause Mode = Process), so this Game script keeps running in order to open/close
	#   the Pause Menu when the player presses the "toggle_pause" action.
	# 2. The Level scene has Pause Mode = Stop (and its child Player scene has Pause Mode = Inherit),
	#   so the gameplay will stop.
	# 3. The InterfaceLayer node has Pause Mode = Inherit, with its child PauseMenu scene having
	#   Pause Mode = Process, so it will continue to process even when the game is paused.
	# To see the Pause Mode of any node, select the node and you'll see "Pause Mode" near the bottom
	# of the Inspector under "Node" fields.
	elif event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_tree().set_input_as_handled()

	elif event.is_action_pressed("splitscreen"):
		#print(name)
		if name == "Splitscreen":
			#print("TAB")
			# We need to clean up a little bit first to avoid Viewport errors.
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://src/Main/Game.tscn")
			#$InterfaceLayer/InGameUI.changeToGameScreen()
		else:
			#print("TAB")
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://src/Main/Splitscreen.tscn")
			#$InterfaceLayer/InGameUI.changeToSplitScreen()
			
func _on_InGameUI_double_jump():#QW when click double jump
	#print("S")
	if $InterfaceLayer/PauseMenu/ColorRect/CoinsCounter.coins_collected>=10:#QW check the amount of coins
		#print("N")
		$InterfaceLayer/PauseMenu/ColorRect/CoinsCounter.coins_collected -= 10#QW spend the coin
		$InterfaceLayer/InGameUI.doublejumped()#QW change ui of double jump
		if $".".name == "Splitscreen":#QW is splitscreen, set 2 players jump
			#print("X")
			$Black/SplitContainer/ViewportContainer1/Viewport1/Level/Player1.avaliableJump += 1#QW
			$Black/SplitContainer/ViewportContainer1/Viewport1/Level/Player2.avaliableJump += 1#QW
		else:#QW
			$Level/Player.avaliableJump += 1#QW
		$InterfaceLayer/InGameUI.doubleJump = true#QW lable is doublejumpable
			

		


func _on_InGameUI_shoot_button():#QW when click shooting Same as double jump
	if $InterfaceLayer/PauseMenu/ColorRect/CoinsCounter.coins_collected>=10:#QW 
		#print("N")
		$InterfaceLayer/PauseMenu/ColorRect/CoinsCounter.coins_collected -= 10#QW
		$InterfaceLayer/InGameUI.shooting()#QW
		if $".".name == "Splitscreen":#QW
			#print("X")
			$Black/SplitContainer/ViewportContainer1/Viewport1/Level/Player1.shootable = true#QW
			$Black/SplitContainer/ViewportContainer1/Viewport1/Level/Player2.shootable = true#QW
		else:#QW
			$Level/Player.shootable = true#QW
		$InterfaceLayer/InGameUI.shoot = true#QW


func _on_Player_lose_live():#QW
		$InterfaceLayer/InGameUI.loseLivePlayer1($Level/Player.lives)#QW update lives bar at game


func _on_Player1_lose_live():#QW
	$InterfaceLayer/InGameUI.loseLivePlayer2($Black/SplitContainer/ViewportContainer1/Viewport1/Level/Player1.lives)#QW upedate player 1 lives bar at splitescreen


func _on_Player2_lose_live():#QW
	$InterfaceLayer/InGameUI.loseLivePlayer1($Black/SplitContainer/ViewportContainer1/Viewport1/Level/Player2.lives)#QW upedate player 2 lives bar at splitescreen


func _on_Player1_game_over():#QW when game over, restart game for splitscreen version
	get_tree().change_scene("res://src/Main/Splitscreen.tscn")#QW
	
func _on_Player2_game_over():#QW for splitscreen version
	get_tree().change_scene("res://src/Main/Splitscreen.tscn")#QW


func _on_Player_game_over():#QW
	get_tree().change_scene("res://src/Main/Game.tscn")#QW
