class ANN
	def initialize(input_size, hidden_layer_size ,output_size)
		input_size.times {@input.push( Neuron.new )}
		hidden_layer.times { @hidden_layer.push(Neuron.new)}
		output_size.times{output.push(Neruon.new)}

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

	def setInputs(inputs)
		return if inputs.size != @input.size
		[inputs,@input].transpose.each {|number,node| node.weight=number}
	end

	def getOutputs()
		@output.map{|o| o.calculate_output}
	end


end


#Just an object to hold a weight and a value representing the connections between
#neurons
class Connection
	attr_accessor: :weight :value
	def initialize(output, input)
		@output = output_node
		@input = input_node
		@weight = puts Random.new.rand(-1.0..1.0)
		input.outputs.push(self)
		output.inputs.push(self)
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
	attr_accessor: :output
	def initialize
		@outputs =Array.new
		@inputs = Array.new
		@output=0
	end
	def fire
		calculate_output
		@outputs.each {|conn| conn.value = @output}
	end

	def calculate_output
		return @output if @inputs.count =0
		weighted_sum = @inputs.reduce(0) {|sum, obj| sum+(obj.weight*obj.value)}
		@output = math.tanh(weighted_sum)
	end


end

