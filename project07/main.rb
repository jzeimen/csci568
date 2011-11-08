#! /usr/bin/env ruby

require './ann_api.rb'

INPUT=[1.0,0.25,-0.5]; OUTPUT=[1,-1.0,0.0]

puts "Input"
puts INPUT
puts
puts "Desired output:"
puts OUTPUT
puts


puts "output before training:"
#Call ANN Paramaters are the number of nodes in input, hidden and output layers
my_ann = ANN.new(3,2,3)
my_ann.set_inputs(INPUT)

#prints outputs before training
puts my_ann.get_outputs
puts

puts "Output after training:"
#trains ann
my_ann.train(INPUT,OUTPUT)

#Prints new traind outputs
puts my_ann.get_outputs
puts 


puts "Absolute value of difference (desired - calculated)"
puts [OUTPUT, my_ann.get_outputs].transpose.map{|x,y| (x-y).abs}
