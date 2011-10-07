#! /usr/bin/env ruby

#This is a simple script that takes in the list of names from the database, and does some things to pick apart the 
#data and quantify it. Later it will be used in weka to see which names are winners and losers


require 'sqlite3'
db = SQLite3::Database.new( "winners_losers.sqlite.db" )
rows = db.execute( "select name, label from people" ) 

header="\"name\",\"winner\",\"firstLetter\",\"letters\",\"secondLetter\",\"vowels\",\"nonVowels\",\"secondLetterVowel\""
rows.each do |row|
	#first letter
	row << row.first[0..0]
#number of letters in name
	row << row.first.count( "a-zA-Z").to_s
#second letter
	row << row.first[1..1]

#number of vowels
	row << row.first.count("aeiou").to_s

#number of nonvowels
	row << row.first.count("bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ").to_s
#Is the second letter a vowel?
	

	row << row.first[1..1].count("aeiou").to_s


end



file = File.open("extraData.csv","w")
file.puts header
rows.each do |row|
	outstring = "";
	row.each do |item|
		#puts item.strip
		outstring +=  "\"#{item.strip}\"" + ","
	end
	#remove that last comma before writing Weka doesn't care for it
	outstring = outstring[0...-1]
	file.print outstring + "\n"
end