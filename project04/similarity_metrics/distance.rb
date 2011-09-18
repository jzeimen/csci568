# Joe Zeimen
# Sept 17, 2011
# Data Mining CSCI568
#Project 4

# This file contains functions to measure distance between objects.

# Each function looks at 2 objects instance variables and calculates the distance between the 
# values in those variables in different ways depending on the function. 

 #Given two objects  it will find the intersection and calculate the 
 #normalized euclidean distance between the two.
def euclidean_distance( dis , dat) 
	attributes = dis.instance_variables & dat.instance_variables
	square_sum =0.0;
	attributes.each do |inst|															
			square_sum += (dat.instance_variable_get(inst) - dis.instance_variable_get(inst))**2	
	end
	return 1/(1+Math.sqrt(square_sum))
end

# Gives the simple matching coefficient between 2 objects. It looks for matching instance variables
# and compares whether or not they have the same true or false value. The number of matching over the 
# total number of attributes it what SMC calculates
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

# Gives the Jaccard coefficient. It is similar to SMC but it does not count instances where both items are 0 or false
# This is usefull for sparse data 
def jaccard_coefficient(dis,dat)
	matching_attributes = 0.0
	denominator =0 
	(dis.instance_variables | dat.instance_variables).each do |var| 
		add_denom = false
		# If either object has a true value we need to count that in the denominator
		if 	(dis.instance_variable_defined?(var) && dis.instance_variable_get(var) == true) ||
			(dat.instance_variable_defined?(var) && dat.instance_variable_get(var) == true)
			denominator +=1
		else
			next #If it doesn't have at least one true we don't care
		end
		if (dis.instance_variable_defined?(var) && dat.instance_variable_defined?(var) ) &&
			 (dis.instance_variable_get(var) == true && dat.instance_variable_get(var) == true)
			matching_attributes +=1
		else
			next #They don't match so we don't add to the numerator
		end
	end
	return 0 if denominator == 0
	matching_attributes/denominator
end

#calculates the cosine simularity. This looks at the angle between 2 vectors
def cosine_similarity(dis,dat)
	dis_length = Math.sqrt(dotproduct(dis,dis))
	dat_length = Math.sqrt(dotproduct(dat,dat))
	(dotproduct(dat,dis)) /(dis_length * dat_length)
end

#Helper function to calculate the dot product between 2 objects
#This function uses the object's instance variables
def dotproduct( first , second)
	common = first.instance_variables & second.instance_variables
	sum =0
	common.each do |inst|
		sum += first.instance_variable_get(inst) * second.instance_variable_get(inst)
	end
	sum
end

#Calculates the standard deviation of all of the instance variables in the object
def std_dev(o)
	average = avg(o)
	sq_dif = 0.0
	o.instance_variables.each do |inst| 
		sq_dif += (o.instance_variable_get(inst)-average)**2
	end
	Math.sqrt((1.0/(o.instance_variables.length-1)) * sq_dif)
end

#calculates the covariance between two object's instance variables
def covariance( this, that  )
	this_average = avg(this)
	that_average = avg(that)
	sum = 0.0
	this.instance_variables.each do |inst|
		sum += (this.instance_variable_get(inst)-this_average)*(that.instance_variable_get(inst)-that_average)
	end
	(1.0/(this.instance_variables.length-1)) * sum
end

#Calculates the average of all of the instance variables in an object
def avg(o)
	sum = 0.0
	o.instance_variables.each do |var|
		sum += o.instance_variable_get(var)
	end
	sum/o.instance_variables.length
end

#Calculates how linearly dependant between both objects
def pearson_correlation_coefficient(dis,dat)
	covariance(dis,dat)/(std_dev(dis)*std_dev(dat))
end