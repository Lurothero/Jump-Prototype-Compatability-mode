# https://gist.github.com/sjvnnings/5f02d2f2fc417f3804e967daa73cccfd

extends CharacterBody2D

@export_category("Movement Properties")
##The speed of which the player moves
@export var movement_speed = 300.0

##Controls how much the player can influence their movement in the air when moving. Closer to 1, the more control the player has while closer to 0 the engine controls the movement
@export_range(0.0,1.0) var air_acceleration_speed:float = 0.01

##Controls how much the player can influence their movement in the air not moving. Closer to 1, the more control the player has while closer to 0 the engine controls the movement
@export_range(0.0,1.0) var air_deceleration_speed:float = 0.01

##Controls how quickly the player reach the maximum speed. Closer to 1, reaches the max speed faster, while closer to 0, reaches max speed slower.
@export_range(0.0,1.0) var ground_acceleration_speed:float = 0.01

##Controls how quickly the player stops moving. Closer to 1 stops the player immediately, while closer to 0, it takes longer to slow down, a very low value can simulate icy floors.
@export_range(0.0,1.0) var ground_deceleration_speed:float = 0.01


@export_category("Jump Properties")
@export var jump_height = 400.0
@export var jump_peak = .2
@export var jump_descend = .1
@export var jumpCount = 2
@export var wall_jump_force = 600
@export_range(0.0,1.0) var variable_jump_damping = 1.0
@export_range(0.0,90.0) var wall_jump_angle:float = 45.0
##Use this to change the jump height after defeating enemies
@export var enemy_jump_height = 200.0

##Ratio of how strong gravity should be affecting when wall sliding. 0 for no gravity(sticking to the wall), while 1 is no influence(effectively no slowdown)
@export_range(0.0,1.0) var wall_slide_speed:float = 0.1


#Helper variables 

@onready var current_wall_slide_speed:float = 1.0
@onready var jump_angle = wall_jump_angle+180
@onready var jump_velocity:float = ((2.0 * jump_height) / jump_peak) * -1.0
@onready var jump_gravity:float = ((-2.0 * jump_height) / (jump_peak * jump_peak)) * -1.0
@onready var fall_gravity:float  = ((-2.0 * jump_height) / (jump_descend * jump_descend)) * -1.0

var jumpCounter = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal jump_refreshed
signal jump_incremented

#TO DO FIX DOUBLE JUMP!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Double jump just works?
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if is_on_wall_only():
		#check my direction and change the gravity
		#compare direction
			var direction_vector:Vector2 = Vector2(Input.get_axis("MoveLeft","MoveRight"),Input.is_action_just_pressed("Jump"))
			var wall_normal = get_wall_normal()
			var dot_product = direction_vector.dot(wall_normal)

			if dot_product == -1:
				current_wall_slide_speed = wall_slide_speed
				velocity.y == 0
			elif dot_product == 0:
				velocity.y += (get_gravity(1.0)*delta)
				current_wall_slide_speed = 1.0#Kinda hard coded but it should be the scale of gravity, which 1 is normal 
		else:
			velocity.y += (get_gravity(1.0)) * delta
		
		
		
	if is_on_floor():
		jump_refreshed.emit()
		
	if Input.is_action_just_pressed("Jump"):
		CMD_JUMP()


	if Input.is_action_just_released("Jump") and velocity.y < 0.0:
		velocity.y = lerp(velocity.y,0.0,variable_jump_damping)


	if is_on_wall_only():
		if Input.is_action_just_pressed("Jump"):
			jump_off_wall()
		
			

				
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("MoveLeft","MoveRight")
	if direction:
		if !is_on_floor():
			velocity.x = lerp(velocity.x,direction * movement_speed,air_acceleration_speed)
		else:
			velocity.x = lerp(velocity.x,direction * movement_speed,ground_acceleration_speed)
	else:
		if !is_on_floor():
			velocity.x = lerp(velocity.x,0.0,air_deceleration_speed)
		else :
			velocity.x = lerp(velocity.x,0.0,ground_deceleration_speed)
			

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("I collided with ", collision.get_normal())

func CMD_JUMP():
	if  jumpCounter < jumpCount:
		velocity.y =  jump_velocity
		jump_incremented.emit()
		
func JUMP_ENEMY():
	velocity.y = enemy_jump_height
		
func get_gravity(gravity_modifier:float)->float:
	if velocity.y < 0.0 :
		return jump_gravity
	else:
		return fall_gravity
	

func refresh_jump():
	if is_on_floor():
		jump_refreshed.emit()

func _on_jump_refreshed() -> void:
	jumpCounter = 0
	pass # Replace with function body.


func _on_jump_incremented() -> void:
	jumpCounter+=1
	pass # Replace with function body.

func jump_off_wall():
		# Use move_and_collide for specific collision handling


		print("You Touched the wall and tried to jump off")
		print(get_last_slide_collision().get_normal())

		#convert degress to radsa
		var angle_in_rads = deg_to_rad(jump_angle)
		#convert x and y with sin and cos

		#watch out for implicit type conversion 
		var x = cos(deg_to_rad(jump_angle))
		var y = sin(deg_to_rad(jump_angle))
	
		var  jump_vector:Vector2 = Vector2(x,y)

		#use this to calculate the jump force by changing the character velocity
		
		var finished_vector:Vector2 =  jump_vector * wall_jump_force
		
		#looks like:
		# 0 degrees is foward 
		# 90 degrees is down
		
		velocity.x = jump_vector.x * wall_jump_force * (get_last_slide_collision().get_normal().x *-1)
		velocity.y = jump_vector.y*wall_jump_force
		
		print ("Velocity is: " + str(velocity.x) + "," + str(velocity.y) )
		pass
