import numpy
import imageio # Helper to load data from PNG image files
import glob # glob helps select multiple files using patterns

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

def load_test_data_from_csv(file_path):
    """
    Load the test data from a CSV file.

    Args:
        file_path (str): Path to the test data CSV file.
    
    Returns:
        list: A list containing the test data.
    """

    test_data_file = open(file_path, 'r')
    test_data_list = test_data_file.readlines()
    test_data_file.close()

    return test_data_list

def load_test_data_from_images(file_path):
    """
    Load the test data from image files.

    Args:
        file_path (str): Path to the test data image files.
    
    Returns:
        list: A list containing the test data.
    """

    dataset = []

    # Load the png image data as test data set
    for image_file_name in glob.glob(file_path):
        
        # Use the filename to set the correct label
        label = int(image_file_name[-5:-4])
        
        # Load image data from png files into an array
        img_array = imageio.imread(image_file_name, mode='L')
        
        # Reshape from 28x28 to list of 784 values, invert values
        img_data  = 255.0 - img_array.reshape(784)
        
        # Scale data to range from 0.01 to 1.0
        img_data = (img_data / 255.0 * 0.99) + 0.01
        #print(numpy.min(img_data))
        #print(numpy.max(img_data))
        
        # Append label and image data  to test data set
        record = numpy.append(label, img_data)
        dataset.append(record)
        
    return dataset