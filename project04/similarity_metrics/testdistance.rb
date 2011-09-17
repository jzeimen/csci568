#! /usr/bin/env ruby
#Joe Zeimen
#Data Mining 


require 'distance.rb'
require 'falseData.rb'

hash = get_song_counts

print_song_counts( hash )

puts euclideanDistance(hash["Joe"], hash["Andy"])

