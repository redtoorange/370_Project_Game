var index
var direction
var distance
var size

# Create a new target based on the JSON data passed in
func _init( i, dir, dis, sz):
	index = i
	direction = dir
	distance = dis
	size = sz
	#print("New target created: ", i, " ", dir, " ", dis, " ", sz)

func printData():
	print("Target: ", index, " ", direction, " ", distance, " ", size)