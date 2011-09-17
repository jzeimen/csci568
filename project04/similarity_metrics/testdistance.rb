#! /usr/bin/env ruby
#Joe Zeimen
#Data Mining 


require 'distance.rb'
require 'falseData.rb'

hash = get_song_counts

# print_song_counts( hash )

puts euclideanDistance(hash["Joe"], hash["Andy"])



Jack = Market_Basket.new(true,false,true,true,true,false,true)
Jill = Market_Basket.new(false,false,true,false,true,true,true)



/Testing Simple Matching Coefficient/
expected = (4.0/7.0)
actual = simple_matching_coefficient(Jack, Jill)
puts   (actual == expected  ? "Pass" :  "Fail") + ": simple_matching_coefficient test"
