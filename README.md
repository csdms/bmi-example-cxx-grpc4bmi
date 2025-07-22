# bmi-example-cxx-grpc4bmi

Set up a [grpc4bmi](https://grpc4bmi.readthedocs.io) server
to run a containerized version
of the [Basic Model Interface](https://bmi.readthedocs.io)
[C++ example](https://github.com/csdms/bmi-example-cxx)
through Python.

## Build

Build this example locally with:
```
docker build --tag bmi-example-cxx-grpc4bmi .
```
The image is built on the [mdpiper/grpc4bmi-154](https://hub.docker.com/r/mdpiper/grpc4bmi-154) base image.
The OS is Linux/Ubuntu.
The C++ BMI example, grpc4bmi, and the grpc4bmi server are installed in `/usr/local`.
The server is exposed through port 55555.

## Run

Use the grpc4bmi [Docker client](https://grpc4bmi.readthedocs.io/en/latest/container/usage.html#docker)
to access the BMI methods of the containerized model.

Install grpc4bmi with *pip*:
```
pip install grpc4bmi
```
Then, in a Python session, access the C++ *Heat* model in the image built above with:
```python
from grpc4bmi.bmi_client_docker import BmiClientDocker


m = BmiClientDocker(image='bmi-example-cxx-grpc4bmi', image_port=55555, work_dir=".")
m.get_component_name()

del m  # stop container cleanly
```

If the image isn't found locally, it's pulled from Docker Hub
(e.g., try the `mdpiper/bmi-example-cxx-grpc4bmi-154` image).

For more in-depth examples of running the *Heat* model through grpc4bmi,
see the [examples](./examples) directory.

## Acknowledgment

This work is supported by the U.S. National Science Foundation under Award No. [2103878](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2103878), *Frameworks: Collaborative Research: Integrative Cyberinfrastructure for Next-Generation Modeling Science*.
