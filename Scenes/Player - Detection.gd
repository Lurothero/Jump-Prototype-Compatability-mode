extends Area2D

@onready var playerKineBody= $".."

##Adjust later, but should all be synced really
@export var hit_delta = 15.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	print(body)
	
	if body.is_in_group("Enemy"):
		print ("Collided with enemy")
		#we want to get the normal of the area 2d body. idk if this is the correct way of doing this but i don't see any other method rn.
		var enemy_position = body.global_position.y
		var player_position = global_position.y	
		print ("Player is " + str (player_position) )
		print ("Enemy is " + str(enemy_position) )
		if enemy_position-player_position > hit_delta:
			#u killed the enemy
			print("BOUNCE")
			playerKineBody.JUMP_ENEMY()
			
		else:
			#take dmg
			print ("Playerasdfsdfsdf")
		
		
	
	pass # Replace with function body.
