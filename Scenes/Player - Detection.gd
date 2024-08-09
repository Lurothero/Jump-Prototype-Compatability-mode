extends Area2D

@onready var playerKineBody= $".."

##Adjust later, but should all be synced really
@export var hit_delta = 15.0


@export_range(0.0,90.0) var knockback_angle:float = 0.0
@export var knockback_force = 1000


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):

	
	if body.is_in_group("Enemy"):
		#we want to get the normal of the area 2d body. idk if this is the correct way of doing this but i don't see any other method rn.
		var enemy_position = body.global_position.y
		var player_position = global_position.y	

		if enemy_position-player_position > hit_delta:
			#u killed the enemy
			playerKineBody.JUMP_ENEMY()
			
		else:
			#determine x axis position
			var player_x = self.global_position.x
			var enemy_x = body.global_position.x
			
			var direction = signf(player_x-enemy_x)
			
			var knockback_angle_in_rads:float = deg_to_rad(knockback_angle)
			
			
			var x:float = cos(knockback_angle_in_rads)
			var y:float = sin(knockback_angle_in_rads)
			
			var knockback_vector = Vector2(cos(knockback_angle_in_rads),sin(knockback_angle_in_rads))
			
			print("KNOCKBACK: " + str(knockback_vector))
			enemy_knockback(knockback_vector,direction)
			#take dmg
			return
		
		
	
	pass # Replace with function body.

func enemy_knockback(vector:Vector2,direction:int):
	playerKineBody.velocity.x = knockback_force*vector.x * direction
	playerKineBody.velocity.y = knockback_force*vector.y *-1
	#Can we get our normal from the enemy
	
	pass
