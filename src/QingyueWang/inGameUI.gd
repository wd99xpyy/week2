extends Control
signal double_jump
signal shoot_button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var doubleJump = false
var shoot = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "0"




func showCoin(amount):#QW show coins on UI
	$Label.text = amount
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func doublejumped():#QW changw ui of double jump
	$DoubleJump/Label.text = "MAX"
	$DoubleJump/Label/AnimatedSprite.hide()

func shooting():#QW  change ui of shooting
	$shooting/Label.text = "MAX"
	$shooting/Label/AnimatedSprite.hide()


func _on_DoubleJump_pressed():#QW when click button
	if(!doubleJump):
		emit_signal("double_jump")#QW sent signal

func loseLivePlayer1(amount):#QW updat player lives
	#print("loseLive")
	# print(amount)
	$Player1/ColorRect.rect_size.x = 10+amount*36
	
func loseLivePlayer2(amount):#QW updat player lives
	#print("loseLive")
	#print(amount)
	$Player2/ColorRect.rect_size.x = 10+amount*36

func changeToSplitScreen(): #QW show player2 lives bar
	#print($Player2.visible)
	$Player2.show()
	
func changeToGameScreen():#QW hide player2 lives bar
	#print($Player2.visible)
	$Player2.hide()

func _on_shooting_pressed():#QW when click button
	if !shoot:
		emit_signal("shoot_button")
