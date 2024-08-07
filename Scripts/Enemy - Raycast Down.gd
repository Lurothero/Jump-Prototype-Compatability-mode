extends RayCast2D
@onready var enemy_kine_body = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if enemy_kine_body.is_on_floor():
		if !is_colliding():
			enemy_kine_body.turn_around.emit()
	
	pass
