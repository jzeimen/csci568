#! /usr/bin/env ruby

require './ann_api.rb'


my_ann = ANN.new(3,2,3)
my_ann.set_inputs([-1,1,1])
my_ann.feed_forward
puts my_ann.get_outputs