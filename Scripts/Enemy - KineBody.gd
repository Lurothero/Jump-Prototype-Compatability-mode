extends CharacterBody2D


var gravity = 3000.0
##Adjust to determine if the player hit the enemy from top or from the sides 
@export var hit_delta = 15.0

func _ready():
	
	
	pass

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	pass
	
func _process(delta):
	
	
	
	pass

func _on_area_2d_area_entered(area):
	
	print(area)
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	
	
	
	if body.is_in_group("Player"):
		print("Player detected")
		var enemy_position = global_position.y
		var player_position = body.global_position.y	
		print ("Player is " + str (player_position) )
		print ("Enemy is " + str(enemy_position) )
		if enemy_position-player_position > hit_delta:
			print ("died")
			
			queue_free()
		else:
			print ("Player Dmg")

	pass # Replace with function body.
