class Flower 
	attr_reader :attributes, :classID
	def initialize(id,attributes,classID)
		@id = id
		@attributes = attributes
		@classID = classID 
	end
	def to_s
		string = String.new
		@attributes.each { |x|  string += x.to_s + " "}
		@id.to_s + " " + @classID.to_s + " " + string
	end

	def distance( otherFlower )
		# Euclidean Distance. Takes both arrays find the difference between elements,
		# square them then add them together and finally find the square root. 
		Math.sqrt([@attributes, otherFlower.attributes].transpose.map{|x,y| (x.to_f-y.to_f)**2}.reduce(0, :+))
	end

	#returns true if it is using the same centroid as previously used
	def add_to_nearest_centroid(centroids)
		nearest = centroids.reduce(centroids.first){|closest, current| self.distance(closest) < self.distance(current) ? closest : current}
		nearest.push self
		return_val = @centroid == nearest ? true : false
		@centroid = nearest
		return_val
	end
end


class Centroid
	attr_reader :attributes, :data_points
	def initialize(id, attributes)
		@id = id
		@attributes = attributes
		@data_points = Array.new
	end
	def push item
		@data_points.push item
	end
	def find_new_average
		temp_array = Array.new
		@data_points.each {|row| temp_array.push row.attributes}
		#Seperates the data into columns
		@attributes=temp_array.transpose.map do |column| 
			#Finds the average of the column
			column.reduce(0){|left, right| left.to_f+right.to_f}/column.length
		end
	end
	def clear_members
		@data_points.clear
	end
	def to_s
		string = String.new
		@attributes.each { |x|  string += x.to_s + " "}
		@id.to_s + " " + @classID.to_s + " " + string + @data_points.length.to_s
	end
end