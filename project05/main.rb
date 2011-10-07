#! /usr/bin/env ruby

require 'sqlite3'
require './data_structures.rb'

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
cluster_sse =0.0
centroids.each do |centroid| 
	puts "Cluster id: " + centroid.id.to_s + "\tNumber of elements: " + centroid.size.to_s
	puts "Cluster SSE: " + centroid.sse.to_s
	centroid.get_class_hash.each_key{|key| puts key.to_s + "\t" + centroid.get_class_hash[key].to_s}

	cluster_sse+=centroid.sse
	cluster = centroid.data_points
	cluster.each do |flower| 
		#Uncomment the next line to see detailed output for flowers
		#puts flower
		sse+= flower.distance(centroid)**2
	end
	puts
	puts
end

puts "Total SSE: " + sse.to_s
puts "Per Cluster SSE Average: " + (cluster_sse/NO_CENTROIDS).to_s
puts "\n\n press ENTER to see weka output for same data"
gets
puts " Example Weka Output
Output from Weka:



=== Run information ===
Scheme:       weka.clusterers.SimpleKMeans -N 3 -S 10
Relation:     iris
Instances:    150
Attributes:   5
              sepallength
              sepalwidth
              petallength
              petalwidth
Ignored:
              class
Test mode:    evaluate on training data

=== Model and evaluation on training set ===


kMeans
======

Number of iterations: 6
Within cluster sum of squared errors: 6.9981140048267605

Cluster centroids:

Cluster 0
	Mean/Mode:  5.8885 2.7377 4.3967 1.418 
	Std Devs:   0.4487 0.2934 0.5269 0.2723
Cluster 1
	Mean/Mode:  5.006  3.418  1.464  0.244 
	Std Devs:   0.3525 0.381  0.1735 0.1072
Cluster 2
	Mean/Mode:  6.8462 3.0821 5.7026 2.0795
	Std Devs:   0.5025 0.2799 0.5194 0.2811

Clustered Instances

0       61 ( 41%)
1       50 ( 33%)
2       39 ( 26%)

"