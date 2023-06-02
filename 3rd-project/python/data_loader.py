import numpy

def load_training_data(file_path):
    """
    Load the training data from a CSV file.

    Args:
        file_path (str): Path to the training data CSV file.

    Returns:
        tuple: A tuple containing the inputs and targets as numpy arrays.
    """
    # Read the training data file
    training_data_file = open(file_path, 'r')
    training_data_list = training_data_file.readlines()
    training_data_file.close()

    # Initialize empty lists for inputs and targets
    inputs = []
    targets = []

    # Process each record in the training data
    for record in training_data_list:
        # Split the record by commas
        all_values = record.split(',')
        # Convert the input values to floats and scale them
        scaled_inputs = (numpy.asfarray(all_values[1:]) / 255.0 * 0.99) + 0.01
        # Create the target output values (all 0.01, except the desired label which is 0.99)
        target = numpy.zeros(10) + 0.01
        target[int(all_values[0])] = 0.99
        # Append the scaled inputs and target to the respective lists
        inputs.append(scaled_inputs)
        targets.append(target)

    # Convert the lists to numpy arrays
    inputs_array = numpy.array(inputs)
    targets_array = numpy.array(targets)

    return inputs_array, targets_array

def load_test_data(file_path):
    # load the mnist test data CSV file into a list
    test_data_file = open(file_path, 'r')
    test_data_list = test_data_file.readlines()
    test_data_file.close()

    return test_data_list
