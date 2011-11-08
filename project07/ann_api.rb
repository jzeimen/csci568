class ANN

	#How fasat the ANN "Learns" The higher this is the more 
	#a single training will influence the ANN range is (0,1)
	LEARNING_RATE= 0.5
	#Number of times teh ANN is "trained" when the training method is called
	TRAINING_ITERATIONS=200

	def initialize(input_size, hidden_layer_size ,output_size)
		@input = Array.new
		@hidden_layer = Array.new
		@output = Array.new
		@input_weights = Array.new
		@output_weights = Array.new

		#Create each layer
		input_size.times {@input.push( Neuron.new )}
		hidden_layer_size.times { @hidden_layer.push(Neuron.new)}
		output_size.times{@output.push(Neuron.new)}

		#Create connections between each layer
		@input.each do |i|
			@hidden_layer.each do |h|
				@input_weights.push(Connection.new(h,i))
			end
		end
		@hidden_layer.each do |h|
			@output.each do |o|
				@output_weights.push(Connection.new(o,h))
			end
		end
	end

	def set_inputs(inputs)
		return if inputs.size != @input.size
		[inputs,@input].transpose.each {|number,node| node.output=number}
	end


	#Maps the array of Nodes to an array of integers 
	def get_outputs;
		feed_forward
		@output.map{|o| o.calculate_output}
	end


	#Trains the ANN
	def train (sample_inputs, expected_outputs)
		set_inputs(sample_inputs)
		TRAINING_ITERATIONS.times do
			feed_forward
			back_propagate(expected_outputs)
		end
	end

	
	private

	#Pushes information through the ANN. This function fires each of the neurons
	#in the input and hidden layers. This then allowes us to pull the results using
	#get_outputs
	def feed_forward
		@input.each {|n| n.fire}
		@hidden_layer.each {|h| h.fire}
	end

	#Using the translated version from collective intelligence 
	def back_propagate(targets)
		#For every actual output and its expected output do...
		[@output, targets].transpose.each do | actual, expected|
			actual.error =   expected - actual.calculate_output
			actual.delta = dsigmoid(actual.output) * actual.error
		end

		#For every hidden node, calculate the error, and delta
		@hidden_layer.each do |hidden_node|
			hidden_node.error = 0.0
			hidden_node.outputs.each do |conn|
				#error is the running total plus the weight of the connection times the connection's 
				#output node's delta
				hidden_node.error= hidden_node.error + conn.weight*conn.output.delta
			end
			hidden_node.delta = hidden_node.error * dsigmoid(hidden_node.output)
		end

		#Update the weights of every connection
		(@output_weights+@input_weights).each do |conn|
			change = conn.output.delta*conn.value
			conn.weight = conn.weight + LEARNING_RATE * change
		end
	end

end


#A the function we use to calculate the output of a node,
#Putting it here lets us swap it out later to decide on the best
#function
def sigmoid(number)
	Math.tanh(number)
	#Change to number if we want linear (easier to debug)
	#number
end

#The derivative of the sigmoid function, Collective Intellegence uses 1-number*number
#I will be using a better approximation since the sum of the weights*values can be
#greater than 1 and less than -1, and the sigmoid function is always positive,
#Thanks to wolframalpha this is the actual derivative
def dsigmoid(number)
	(4*Math.cosh(number)**2)/(1+Math.cosh(2*number))**2
	#change return value to 1 if we are doing it linearly like above (easier to debug)
	#1
end


#Just an object to hold a weight and a value representing the connections between
#neurons
class Connection
	attr_accessor :weight, :value, :output
	def initialize(output_node, input_node)
		@output = output_node
		@input = input_node
		@weight = Random.new.rand(-1.0..1.0)
		#for testing and debugging, setting to .5 simply so we know exactly what nubmers should be where
		#@weight = 0.5
		@input.outputs.push(self)
		@output.inputs.push(self)
	end
end



#Neurons are connected by Connection objects. A neuron has an output value calculated 
#from a sum of inputs and weights and applied to the sigmoid function tanh
#firing a neuron grabs information from its connections (if it has any) and calculates
#its output and sends it to all of its output connections
#if it does not have any input connections, it uses the output instance variable. This
#means it is the input layer of neurons.
#If it does not have any outputs, it means it is the output layer.
class Neuron
	attr_accessor :outputs, :inputs, :output
	def initialize
		@outputs =Array.new
		@inputs = Array.new
		@output=0.0

		#Info to back propagate
		@error = 0.0
		@delta = 0.0
	end


	def fire
		calculate_output
		@outputs.each {|conn| conn.value = @output}
	end

	#Takes in data from input connections, and figures out its value
	def calculate_output
		return @output if @inputs.count == 0 #When this node is an input node, we shouldn't try and calculate output
		weighted_sum = @inputs.reduce(0) {|sum, obj| sum+(obj.weight*obj.value)}
		@output = sigmoid(weighted_sum)
	end

	#Also can store information about iteself for back propagation
	attr_accessor :error, :delta

end

