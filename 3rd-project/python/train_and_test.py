# ======= Classification of Handwritten Digits =======
# @ISEL, 2022-2023 Summer Semester
# BSc in Computer Science and Engineering
# Artificial Intelligence
# ====================================================
# Authors:
#   - 48280 André Jesus
#   - 48287 Nyckollas Brandão
# Professor:
#   - Nuno Leite
# ====================================================

import numpy
from neuralnetwork import NeuralNetwork
from data_loader import load_training_data, load_test_data_from_csv, load_test_data_from_images

def train_neural_network(training_data):
    """
    Train the neural network using the loaded training data.

    Args:
        training_data (list): The data to be used for training.
    """
    # Retrieve the loaded training data
    inputs, targets = training_data

    # Iterate through each training record and train the network
    for i in range(len(inputs)):
        # Extract the input and target values for the current record
        inputs_record = inputs[i]
        targets_record = targets[i]

        # Train the neural network with the current record
        n.train(inputs_record, targets_record)

def test_neural_network_with_csv(user_test_data):
    """
    Test the neural network using the provided test data.

    Args:
        user_test_data (list): The test data to be used for testing.
    
    Returns:
        float: The performance of the neural network.
    """

    # Scorecard for how well the network performs, initially empty
    scorecard = []

    # Go through all the records in the test data set
    for record in user_test_data:
        # Split the record by the ',' commas
        all_values = record.split(',')
        # Correct answer is the first value
        correct_label = int(all_values[0])
        # Scale and shift the inputs
        inputs = (numpy.asfarray(all_values[1:]) / 255.0 * 0.99) + 0.01
        # Query the network
        outputs = n.query(inputs)
        # The index of the highest value corresponds to the label
        label = numpy.argmax(outputs)
        # Append correct or incorrect to the scorecard
        if label == correct_label:
            # Network's answer matches correct answer, add 1 to scorecard
            scorecard.append(1)
        else:
            # Network's answer doesn't match correct answer, add 0 to scorecard
            scorecard.append(0)

    # Calculate the performance score, the fraction of correct answers
    scorecard_array = numpy.asarray(scorecard)
    performance = scorecard_array.sum() / scorecard_array.size
    return performance

def test_neural_network_with_images(user_test_data):
    """
    Test the neural network using the provided test data.

    Args:
        user_test_data (list): The test data to be used for testing.
    
    Returns:
        float: The performance of the neural network.
    """

    # Scorecard for how well the network performs, initially empty
    scorecard = []

    # Go through all the records in the test data set
    for record in range(len(user_test_data)):
        # Correct answer is the first value
        correct_label = user_test_data[record][0]
        
        # Scale and shift the inputs
        inputs = user_test_data[record][1:]
        
        # Query the network
        outputs = n.query(inputs)
        
        # The index of the highest value corresponds to the label
        label = numpy.argmax(outputs)
        # Append correct or incorrect to the scorecard
        if label == correct_label:
            # Network's answer matches correct answer, add 1 to scorecard
            scorecard.append(1)
        else:
            # Network's answer doesn't match correct answer, add 0 to scorecard
            scorecard.append(0)

    # Calculate the performance score, the fraction of correct answers
    scorecard_array = numpy.asarray(scorecard)
    performance = scorecard_array.sum() / scorecard_array.size
    return performance

if __name__ == '__main__':
    # Main script
    input_nodes = 784
    hidden_nodes = 200
    output_nodes = 10
    learning_rate = 0.1

    # Create instance of neural network
    print("Creating neural network...")
    n = NeuralNetwork(input_nodes, hidden_nodes, output_nodes, learning_rate)

    # Load the MNIST training data
    print("Loading training data...")
    training_data = load_training_data("mnist_dataset/mnist_train.csv")
    print("Training data loaded.")

    # Train the neural network
    print("Training neural network...")
    train_neural_network(training_data)
    print("Neural network trained.")

    # Test the neural network
    print("Test the neural network:")
    print("1 - Test the neural network with CSV test data")
    print("2 - Test the neural network with image test data")

    # Prompt the user for the test type
    test_type = input("Enter the test type: ")

    performance = 0
    if test_type == "1":
        file_path = "mnist_dataset/mnist_test.csv"
        test_data = load_test_data_from_csv(file_path)
        performance = test_neural_network_with_csv(test_data)
    elif test_type == "2":
        file_path = "my_own_images/2828_my_own_?.png"
        test_data = load_test_data_from_images(file_path)
        performance = test_neural_network_with_images(test_data)
    else:
        print("Invalid test type.")
        exit()
    
    print("Performance = " + str(performance))
