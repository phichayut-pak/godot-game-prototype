extends CharacterBody2D
var state = "stand"
var isSprint = false
var attackRightMode = false

func _ready():
	#$CollisionShape2D.set_deferred("disabled", true)
	var hitbox_collision_right_2 = get_node("AnimatedSprite2D/AttackHitbox/CollisionRight2")
	var hitbox_collision_left_2 = get_node("AnimatedSprite2D/AttackHitbox/CollisionLeft2")
	hitbox_collision_right_2.disabled = true
	hitbox_collision_left_2.disabled = true
	
	var hitbox_collision_right_1 = get_node("AnimatedSprite2D/AttackHitbox/CollisionRight1")
	var hitbox_collision_left_1 = get_node("AnimatedSprite2D/AttackHitbox/CollisionLeft1")
	hitbox_collision_right_1.disabled = true
	hitbox_collision_left_1.disabled = true
	
	

	pass

func _process(delta):
	var sprite = self.get_node("AnimatedSprite2D")
	var hitbox_collision_right_2 = get_node("AnimatedSprite2D/AttackHitbox/CollisionRight2")
	var hitbox_collision_left_2 = get_node("AnimatedSprite2D/AttackHitbox/CollisionLeft2")
	var hitbox_collision_right_1 = get_node("AnimatedSprite2D/AttackHitbox/CollisionRight1")
	var hitbox_collision_left_1 = get_node("AnimatedSprite2D/AttackHitbox/CollisionLeft1")

	# Check for attack action just pressed
	if Input.is_action_just_pressed("attack"):
		self.get_parent().get_parent().get_node("SlashSound").play()
		if(sprite.flip_h):
			hitbox_collision_left_1.disabled = false
			hitbox_collision_left_2.disabled = false
			
			hitbox_collision_right_1.disabled = true
			hitbox_collision_right_2.disabled = true

		else:
			hitbox_collision_left_1.disabled = true
			hitbox_collision_left_2.disabled = true
			
			hitbox_collision_right_1.disabled = false
			hitbox_collision_right_2.disabled = false
		self.velocity.x = 0
		self.velocity.y = 0
		if attackRightMode:
			state = "attackRight2"
		else:
			state = "attackRight1"
		attackRightMode = !attackRightMode  # Toggle the attack mode for next time
	elif sprite.is_playing() and (state == "attackRight1" or state == "attackRight2"):
		if(state == "attackRight1" and sprite.get_frame() >= 4):
			state = "stand"
		elif(state == "attackRight2" and sprite.get_frame() >= 5):
			state = "stand"
		pass
	else:
		hitbox_collision_right_1.disabled = true
		hitbox_collision_left_1.disabled = true
		hitbox_collision_right_2.disabled = true
		hitbox_collision_left_2.disabled = true
		# Handle movement states
		if Input.is_action_pressed("left"):
			state = "walkLeft"
		elif Input.is_action_pressed("right"):
			state = "walkRight"
		elif Input.is_action_pressed("up"):
			state = "walkUp"
		elif Input.is_action_pressed("down"):
			state = "walkDown"
		else:
			state = "stand"
	if(Input.is_action_pressed("shift")):
		isSprint = true
	else:
		isSprint = false
			


	# Apply the current state
	apply_state(state, delta)

func apply_state(state, delta):
	var sprite = self.get_node("AnimatedSprite2D")
	match state:
		"stand":
			sprite.play("stand")
			self.velocity = Vector2.ZERO
		"walkLeft":
			sprite.play("walkRight")
			sprite.flip_h = true
			if(isSprint):
				self.velocity.x = -130 * delta
			else:
				self.velocity.x = -110 * delta
		"walkRight":
			sprite.play("walkRight")
			sprite.flip_h = false
			
			if(isSprint):
				self.velocity.x = 130 * delta
			else:
				self.velocity.x = 130 * delta
				
		"walkUp", "walkDown":
			sprite.play("walkRight")
			if(state == "walkUp"):
				if(isSprint):
					self.velocity.y = -1 * 130 * delta
				else:
					self.velocity.y = -1 * 110 * delta
			else:
				if(isSprint):
					self.velocity.y = 1 * 130 * delta
				else:
					self.velocity.y = 1 * 110 * delta
		"attackRight1", "attackRight2":
			sprite.play(state)

	self.position += self.velocity
	self.move_and_slide()




func take_damage(amount):
	modulate = Color(1, 0, 0, 1)
	await get_tree().create_timer(0.2).timeout
	modulate = Color(1, 1, 1, 1)
	


func _on_hitbox_attack_right_1_body_entered(body):
	var enemies = ["Enemy1", "Enemy2", "Enemy3", "Enemy4", "Enemy5"]
	if(body.name in enemies):
		
		print("hit")
		body.modulate = Color(1, 0, 0)
		await get_tree().create_timer(0.2).timeout
		body.modulate = Color(1, 1, 1)
		
		await get_tree().create_timer(0.2).timeout
		self.get_parent().get_parent().get_node("DamageSound").play()
		body.queue_free()
