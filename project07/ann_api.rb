class ANN
	def initialize(input_size, hidden_layer_size ,output_size)
		@input = Array.new
		@hidden_layer = Array.new
		@output = Array.new
		@input_weights = Array.new
		@output_weights = Array.new
		input_size.times {@input.push( Neuron.new )}
		hidden_layer_size.times { @hidden_layer.push(Neuron.new)}
		output_size.times{@output.push(Neuron.new)}

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


	#Pushes information through the ANN. This function fires each of the neurons
	#in the input and hidden layers. This then allowes us to pull the results using
	#get_outputs
	def feed_forward
		@input.each {|n| n.fire}
		@hidden_layer.each {|h| h.fire}
	end

	def set_inputs(inputs)
		return if inputs.size != @input.size
		[inputs,@input].transpose.each {|number,node| node.output=number}
	end


	#Maps the array of Nodes to an array of integers 
	def get_outputs;
		@output.map{|o| o.calculate_output}
	end

	#
	def back_propagate

	end

end


#A the function we use to calculate the output of a node,
#Putting it here lets us swap it out later to decide on the best
#function
def sigmoid(number)
	Math.tanh(number)
end

#The derivative of the sigmoid function, Collective Intellegence uses 1-number*number
#I will be using a better approximation since the sum of the weights*values can be
#greater than 1 and less than -1, and the sigmoid function is always positive,
#Thanks to wolframalpha this is the actual derivative
def dsigmoid(number)
	(4*Math.cosh(x)^2)/(1+Math.cosh(2*x))^2
end


#Just an object to hold a weight and a value representing the connections between
#neurons
class Connection
	attr_accessor :weight, :value
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
		@output=0
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


end

