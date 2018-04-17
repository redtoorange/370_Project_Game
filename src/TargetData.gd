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

#Debug function to print the target's data that was read from the file
func printData():
	print("Target: ", index, " ", direction, " ", distance, " ", size)