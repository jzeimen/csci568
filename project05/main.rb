#! /usr/bin/env ruby

require 'sqlite3'
require 'data_structures.rb'


db = SQLite3::Database.new( "iris.sqlite3.db" )
rows = db.execute( "select * from iris" ) 

flowers=Array.new

rows.each do |row|
	 flowers.push(Flower.new(row[0], row[1..4], row[5]))
end


centroid = Centroid.new("1",  [5.1, 3.5, 1.4, 0.2])
centroid2 = Centroid.new("2",  [5.1, 3.5, 2.4, 1.2])

flowers[0].add_to_nearest_centroid([centroid, centroid2])
puts centroid
puts centroid2

