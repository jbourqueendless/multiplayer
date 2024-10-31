extends Camera2D

@export var move_speed = 0.5
@export var zoom_speed = 0.05
@export var min_zoom = 1.5
@export var max_zoom = 5
@export var margin = Vector2 (400, 200)

var targets = []

@onready var screen_size = get_viewport_rect().size

func add_target(t):
	if not t in targets:
		targets.append(t)
		
func remove_target(t):
	if t in targets:
		targets.remove(t)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !targets:
		return
	#keep the camera centered between the targets
	var p = Vector2.ZERO
	for target in targets:
		p+= target.position
	p /= targets.size()
	position = lerp (position, p, move_speed)
	
	#find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y,
							margin.x, margin.y)
	var d = max (r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x,
					min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y,
					min_zoom, max_zoom)
	zoom = lerp (zoom, Vector2.ONE * z, zoom_speed)
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
