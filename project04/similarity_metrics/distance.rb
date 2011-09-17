


 # Given 2 hashes with name and number key value pairs it will find the intersection and calculate the 
 #normalized euclidean distance between the two.
def euclideanDistance( dis , dat) 
	# Finds intersection between the two hashes by giving an array of the keys that are common between the two
	common_keys = dis.keys & dat.keys

	return 0 if common_keys.empty?

	square_sum = 0
	common_keys.each do |song|
		square_sum += (dis[song] - dat[song] ) ** 2

	end
	return 1/(1+Math.sqrt(square_sum))
end