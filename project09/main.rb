#! /usr/bin/env ruby


require './load_data.rb'
require './active_record_classes.rb'
require './helpers_functions.rb'

################## Get Data ready ###########################
#Loads data from text files and puts it into a sqlite3 db.
#Once this has been done once it is not needed and takes a very long time
#so it is commented out
load_data
calculate_genre_scores


rmse5 = find_rmse(5)
puts "RMSE:"
puts rmse5
