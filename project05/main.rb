#! /usr/bin/env ruby

require 'sqlite3'
require 'data_structures.rb'

#Some variables we may want to tinker with
NO_CENTROIDS = 3
MAX_ITERATIONS = 10



#Get data out of the database and into something easier to use
db = SQLite3::Database.new( "iris.sqlite3.db" )
rows = db.execute( "select * from iris" ) 



#Step 1: Get list of data points ready.
flowers=Array.new
rows.each do |row|
	 flowers.push(Flower.new(row[0], row[1..4], row[5]))
end


#Step 2: Get centroids ready
#Calculate Max and Min for each attribute
temp_array = Array.new
flowers.each do |flower|
	temp_array.push(flower.attributes)
end
maximum = temp_array.transpose.map{ |x| x.reduce(x.first){|prev, this|  prev.to_f > this.to_f ? prev : this}}
minimum =  temp_array.transpose.map{ |x| x.reduce(x.first){|prev, this|  prev.to_f < this.to_f ? prev : this}}

centroids = Array.new
#Create NO_Centroids
(1..NO_CENTROIDS).each do |id_number| 
	centroids.push(Centroid.new(id_number, [maximum,minimum].transpose.map{|max,min| rand * (max.to_f-min.to_f) + min.to_f}))
end


iterations = 0
(1..MAX_ITERATIONS).each do |iter|
	iterations = iter
	
	#Saves orphaned centroids by moving them somewhere else and trying again. 
	centroids.each do |cent| 
		cent.attributes = [maximum,minimum].transpose.map{|max,min| rand * (max.to_f-min.to_f) + min.to_f} if cent.attributes.size == 0
	end
	#Step 3: Attribute each datamember to centroid
	flowers.each do |flower|
		flower.add_to_nearest_centroid(centroids)
	end

	#Step 4: Center Centroids
	centroids.each {|centroid| centroid.find_new_average}
	#Step 5: Remove previous assignents from centroids.
	centroids.each {|centroid| centroid.clear_members} if(iter != MAX_ITERATIONS) 
end


puts 
sse = 0.0
centroids.each do |centroid| 
	puts "Cluster id: " + centroid.id.to_s + "\tNumber of elements: " + centroid.size.to_s
	cluster = centroid.data_points
	cluster.each do |flower| 
		sse+= flower.distance(centroid)**2
	end
end

puts "Total SSE: " + sse.to_s
