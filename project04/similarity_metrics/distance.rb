


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


/Gives the simple matching coefficient between 2 objects. It looks for matching instance variables
and compares whether or not they have the same true or false value. The number of matching over the 
total number of attributes it what SMC calculates/
def simple_matching_coefficient( dis, dat)
	attributes = dis.instance_variables & dat.instance_variables
	matching_attributes = 0.0
	dis.instance_variables.each do |inst|
		if( dat.instance_variable_defined?(inst) && dat.instance_variable_get(inst) == dis.instance_variable_get(inst) )
			matching_attributes +=1
		end
	end
	matching_attributes/attributes.length
end