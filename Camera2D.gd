extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = self.get_parent().get_node("TileMap").get_node("Player").position
	position.y += 400
	position.x += 100
	pass
