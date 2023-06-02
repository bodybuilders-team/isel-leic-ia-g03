# Adapted from "Make Your Own Neural Network" by Tariq Rashid, 2016
# code for a 3-layer neural network, and code for learning the MNIST dataset

import numpy
import scipy.special

# Neural network class definition
class NeuralNetwork:
    
    def __init__(self, inputnodes, hiddennodes, outputnodes, learningrate):
        """
        Initialize the neural network.

        Args:
            inputnodes (int): Number of nodes in the input layer.
            hiddennodes (int): Number of nodes in the hidden layer.
            outputnodes (int): Number of nodes in the output layer.
            learningrate (float): Learning rate for weight updates.
        """
        # Set number of nodes in each layer
        self.inodes = inputnodes
        self.hnodes = hiddennodes
        self.onodes = outputnodes
        
        # Link weight matrices, wih and who
        self.wih = numpy.random.normal(0.0, pow(self.inodes, -0.5), (self.hnodes, self.inodes))
        self.who = numpy.random.normal(0.0, pow(self.hnodes, -0.5), (self.onodes, self.hnodes))

        # Set learning rate
        self.lr = learningrate
        
        # Activation function is the sigmoid function
        self.activation_function = lambda x: scipy.special.expit(x)

    def train(self, inputs_list, targets_list):
        """
        Train the neural network.

        Args:
            inputs_list (list): Input values for training.
            targets_list (list): Target output values.

        """
        # Convert inputs and targets to 2D arrays
        inputs = numpy.array(inputs_list, ndmin=2).T
        targets = numpy.array(targets_list, ndmin=2).T
        
        # Calculate signals into hidden layer
        hidden_inputs = numpy.dot(self.wih, inputs)
        # Calculate the signals emerging from the hidden layer
        hidden_outputs = self.activation_function(hidden_inputs)
        
        # Calculate signals into final output layer
        final_inputs = numpy.dot(self.who, hidden_outputs)
        # Calculate the signals emerging from the final output layer
        final_outputs = self.activation_function(final_inputs)
        
        # Calculate output layer error (target - actual)
        output_errors = targets - final_outputs
        # Calculate hidden layer error by backpropagating the errors
        hidden_errors = numpy.dot(self.who.T, output_errors) 
        
        # Update the weights for the links between the hidden and output layers
        self.who += self.lr * numpy.dot((output_errors * final_outputs * (1.0 - final_outputs)), numpy.transpose(hidden_outputs))
        
        # Update the weights for the links between the input and hidden layers
        self.wih += self.lr * numpy.dot((hidden_errors * hidden_outputs * (1.0 - hidden_outputs)), numpy.transpose(inputs))

    def query(self, inputs_list):
        """
        Query the neural network with input values.

        Args:
            inputs_list (list): Input values for querying the network.

        Returns:
            numpy.ndarray: The output values of the neural network.
        """
        # Convert inputs to 2D array
        inputs = numpy.array(inputs_list, ndmin=2).T
        
        # Calculate signals into hidden layer
        hidden_inputs = numpy.dot(self.wih, inputs)
        # Calculate the signals emerging from the hidden layer
        hidden_outputs = self.activation_function(hidden_inputs)
        
        # Calculate signals into final output layer
        final_inputs = numpy.dot(self.who, hidden_outputs)
        # Calculate the signals emerging from the final output layer
        final_outputs = self.activation_function(final_inputs)
        
        return final_outputs
