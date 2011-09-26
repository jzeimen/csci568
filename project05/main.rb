#! /usr/bin/env ruby

require 'sqlite3'

class Flower 
	def initialize(id,attributes,classID)
		@id = id
		@attributes = attributes
		@classID = classID 
	end
	def to_s
		string = String.new
		@attributes.each { |x|  string += x.to_str + " "}
		@id.to_s + " " + @classID.to_s + " " + string
	end
end




db = SQLite3::Database.new( "iris.sqlite3.db" )
rows = db.execute2( "select * from iris" ) 

flowers=Array.new

rows.each do |row|
	 flowers.push(Flower.new(row[0], row[1..4], row[5]))
end

flowers.each {|x| puts x}


def kmeans()


end


