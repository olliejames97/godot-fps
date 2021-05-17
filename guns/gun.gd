extends Spatial




var recoil_speed = 0.008

var original_position
var pos

var translate 
# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = get_translation()
	pass # Replace with function body.

func fire():
	print("fire")
	
	set_translation(Vector3(pos.x , pos.y, pos.z + 0.06))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pos = get_translation()
	if pos.z > original_position.z:
		print(original_position.z)
		set_translation(Vector3(pos.x, pos.y, pos.z - recoil_speed))
#	pass
