#! /usr/bin/env ruby
# Joe Zeimen
# Sept 17, 2011
# Data Mining CSCI568
#Project 4

require 'distance.rb'

class Market_Basket 
	def initialize(a, b, c, d, e, f, g)
		@apples 	= a
		@bananas 	= b
		@candy 		= c
		@dates 		= d
		@eclair 	= e
		@frosting 	= f
		@grapes 	= g
	end
end

class Song_Counts
	def initialize(a, b, c, d, e, f, g)
		@song1= a
		@song2= b
		@song3= c
		@song4= d
		@song5= e
		@song6= f
		@song7= g
	end
end

#Fake data for market basket type data
Jack = Market_Basket.new(true,false,true,true,true,false,true)
Jill = Market_Basket.new(false,false,true,false,true,true,true)

#fake data for other types of data
Joe = Song_Counts.new(20,22,2,93,4,5,8)
Andy = Song_Counts.new(50,13,2,44,3,6,2)

# Because all of our functions are basically the same format. Here is a function to test a function. Given the function args
# expected and function symbol. Also playing with ruby since this is my first time using it
def test_func(dis, dat, func, expected)
	actual = send(func,dis, dat)
	puts (actual == expected  ? "Pass" :  "Fail") + ": " +  func.to_s + " test"
end

# Testing Euclidean Distance
expected = 1/(1+Math.sqrt(  (50-20.0)**2 + (22.0-13)**2  + (2.0-2)**2 + (93.0-44)**2 + (4.0-3)**2 +(5.0-6)**2 + (8.0-2)**2 ))
test_func(Joe, Andy, :euclidean_distance, expected)

# Testing Simple Matching Coefficient
expected = (4.0/7.0)
test_func(Jack, Jill, :simple_matching_coefficient, expected)

# Testing Jaccard
expected = (3.0/6)
test_func(Jack, Jill, :jaccard_coefficient, expected)

# Testing Pearson Correlation Coefficient
joe_average=(20.0+22+2+93+4+5+8)/7
andy_average=(50.0+13+2+44+3+6+2)/7
			#Wrong calculations when return added to break up lines?
joe_std_dev = Math.sqrt( (1.0/6) *((20-joe_average)**2 + (22-joe_average)**2 + (2-joe_average)**2 + (93-joe_average)**2 +  (4-joe_average)**2 + (5-joe_average)**2 + (8-joe_average)**2 ))
andy_std_dev = Math.sqrt( (1.0/6) * ((50-andy_average)**2 + (13-andy_average)**2 +(2-andy_average)**2 + (2-andy_average)**2 +  (44-andy_average)**2 + (3-andy_average)**2 + (6-andy_average)**2 ) )

covar = (1.0/6) * (  (20-joe_average)*(50-andy_average) +(22-joe_average)*(13-andy_average) + (2-joe_average)*(2-andy_average) + (93-joe_average)*(44-andy_average) +(4-joe_average)*(3-andy_average) +(5-joe_average)*(6-andy_average) +	(8-joe_average)*(2-andy_average)  )
expected =  covar/(joe_std_dev*andy_std_dev) #Should be 0.69425792139928 according to google docs
test_func(Joe, Andy, :pearson_correlation_coefficient, expected)

# Testing Cosine Similarity
expected = (20*50 + 22*13 + 2*2 + 93*44 + 4*3 + 5*6 + 8*2) / 
			(  Math.sqrt(20*20 + 22*22 + 2*2 + 93*93 + 4*4 + 5*5 + 8*8) * Math.sqrt(50*50 + 13*13 + 2*2 + 44*44 + 3*3 + 6*6 +2*2)  )
test_func(Joe, Andy, :cosine_similarity, expected)
