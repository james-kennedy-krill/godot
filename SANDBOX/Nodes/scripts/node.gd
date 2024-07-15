extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print("_ready")
	var child_count = get_child_count()
	print("%d children in this node" % child_count)
	var node_path = get_path()
	print(node_path)
	var child_node = get_child(0)
	child_node.name = "ChildNode1Renamed"
	var metaData = get_meta_list()
	print(metaData)
	var isNode = get_meta("isNode")
	print("isNode %s" % isNode)
	var propertyList = get_property_list()
	print(propertyList)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("_process")
	#print(delta)
	pass


func _physics_process(delta):
	#print("_physics_process")
	#print(delta)
	pass
	
func _enter_tree():
	print("_enter_tree")
	
func _exit_tree():
	print("_exit_tree")
	
func _init():
	print("_init")
	
func _input(event):
	#print("_input")
	#print(event)
	pass


func _on_child_node_1_ready():
	print("ChildNode1 ready")


func _on_child_node_1_renamed():
	print("ChildNode1 renamed")
