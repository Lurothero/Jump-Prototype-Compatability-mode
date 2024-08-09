extends CharacterBody2D


var gravity = 200
##Adjust to determine if the player hit the enemy from top or from the sides 
@export var hit_delta = 15.0

var direction = -1

@export_category("Enemy Properties")
@export var movement_speed = 25


signal turn_around

func _ready():
	
	
	
	
	pass

func _physics_process(delta):
	
	velocity.y += gravity * delta
	velocity.x = (movement_speed*direction)

	move_and_slide()
	pass
	
func _process(delta):
	
	pass

func _on_area_2d_area_entered(area):

	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	
	if body.is_in_group("Player"):
	
		var enemy_position = global_position.y
		var player_position = body.global_position.y	

		if enemy_position-player_position > hit_delta:
	
			
			queue_free()
		else:
			return
	pass # Replace with function body.


func _on_turn_around():
	
	direction = direction * -1
	scale.x = scale.x * -1
	
	pass # Replace with function body.
