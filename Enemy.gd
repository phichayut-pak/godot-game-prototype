extends CharacterBody2D
var state = "stand"
var attackRightMode = false

func _ready():
	pass

func _process(delta):
	var sprite = self.get_node("AnimatedSprite2D")
	sprite.play("stand")



	




