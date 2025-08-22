#!/usr/bin/env python
# Run the C++ `Heat` model in Python through [grpc4bmi](https://grpc4bmi.readthedocs.io).
# 
# `Heat` models the diffusion of temperature on a uniform rectangular plate with Dirichlet boundary conditions.
# View the model source code and its BMI at https://github.com/csdms/bmi-example-cxx.

# Start by importing some helper libraries.
import os
import pathlib
import numpy as np

# Next, import the grpc4bmi Docker client.
from grpc4bmi.bmi_client_docker import BmiClientDocker

# Set variables:
# * which Docker image to use,
# * the port exposed through the image, and
# * the location in the image of the configuration file used for the model.
DOCKER_IMAGE = "csdms/bmi-example-cxx-grpc4bmi:latest"
BMI_PORT = 55555
CONFIG_FILE = pathlib.Path("/opt/bmi-example-cxx") / "testing" / "config.txt"

# Create a model instance (`m`) through the grpc4bmi Docker client.
m = BmiClientDocker(image=DOCKER_IMAGE, image_port=BMI_PORT, work_dir=".")

# Show the name of this model.
print(m.get_component_name())

# Start the `Heat` model through its BMI using a configuration file.
m.initialize(str(CONFIG_FILE))

# Show the input and output variables for the component.
print(m.get_input_var_names())
print(m.get_output_var_names())

# Check the time information for the model.
print("Start time:", m.get_start_time())
print("End time:", m.get_end_time())
print("Current time:", m.get_current_time())
print("Time step:", m.get_time_step())
print("Time units:", m.get_time_units())

# Get the identifier for the grid on which the temperature variable is defined.
grid_id = m.get_var_grid("plate_surface__temperature")
print("Grid id:", grid_id)

# Get grid attributes.
print("Grid type:", m.get_grid_type(grid_id))
rank = m.get_grid_rank(grid_id)
print("Grid rank:", rank)
shape = np.ndarray(rank, dtype=int)
m.get_grid_shape(grid_id, shape)
print("Grid shape:", shape)
spacing = np.ndarray(rank, dtype=float)
m.get_grid_spacing(grid_id, spacing)
print("Grid spacing:", spacing)

# Through the model's BMI, zero out the initial temperature field, except for an
# impulse near the middle. Note that *set_value* expects a one-dimensional array
# for input.
temperature = np.zeros(shape)
temperature[3, 4] = 100.0
m.set_value("plate_surface__temperature", temperature)

# Check that the temperature field has been updated. Note that *get_value*
# expects a one-dimensional array to receive output.
temperature_flat = np.empty_like(temperature).flatten()
m.get_value("plate_surface__temperature", temperature_flat)
print(temperature_flat.reshape(shape))

# Advance the model by a single time step.
m.update()

# View the new state of the temperature field.
m.get_value("plate_surface__temperature", temperature_flat)
print(temperature_flat.reshape(shape))

# Advance the model to some distant time.
distant_time = 10*m.get_time_step()
while m.get_current_time() < distant_time:
    m.update()

# View the final state of the temperature field.
m.get_value("plate_surface__temperature", temperature_flat)
np.set_printoptions(formatter={"float": "{: 5.1f}".format})
print(temperature_flat.reshape(shape))

# Note that temperature isn't conserved on the plate.
print(temperature_flat.sum())

# Stop the model and clean up any resources it allocates.
m.finalize()

# Stop the container running through grpc4bmi.
# This is needed by grpc4bmi to properly deallocate the resources it uses.
# It may take a few moments.
del m
