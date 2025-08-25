[![Basic Model Interface](https://img.shields.io/badge/CSDMS-Basic%20Model%20Interface-green.svg)](https://bmi.readthedocs.io/)
[![Test](https://github.com/csdms/bmi-example-cxx-grpc4bmi/actions/workflows/test.yml/badge.svg)](https://github.com/csdms/bmi-example-cxx-grpc4bmi/actions/workflows/test.yml)
[![Docker Hub](https://github.com/csdms/bmi-example-cxx-grpc4bmi/actions/workflows/release.yml/badge.svg)](https://github.com/csdms/bmi-example-cxx-grpc4bmi/actions/workflows/release.yml)
![Docker Image Version](https://img.shields.io/docker/v/csdms/bmi-example-cxx-grpc4bmi)

# bmi-example-cxx-grpc4bmi

Set up a [grpc4bmi](https://grpc4bmi.readthedocs.io) server
to run a containerized version
of the [Basic Model Interface](https://bmi.readthedocs.io) (BMI)
[C++ example](https://github.com/csdms/bmi-example-cxx)
through Python.

## Build

There are two options for building this project:

1. from a base image, [source-base](./images/source-base/), where grpc and its dependent libraries, grpc4bmi, and the BMI C++ example are all built from source
1. from a base image, [conda-base](./images/conda-base/), where grpc and its dependent libraries are installed through conda-forge, the BMI C++ example is installed from a separate conda-based Docker image, and grpc4bmi is built from source

In each case, the grpc4bmi server is exposed through port 55555.

### source-base

Build this example locally with:
```
docker build --tag bmi-example-cxx-grpc4bmi images/source-base
```
The image is (temporarily) built on the [mdpiper/grpc4bmi](https://hub.docker.com/r/mdpiper/grpc4bmi) base image.
The OS is Linux/Ubuntu.
The C++ BMI example, grpc4bmi, and the grpc4bmi server are installed in `/usr/local`.

### conda-base

Build this example locally with:
```
docker build --tag bmi-example-cxx-grpc4bmi images/conda-base
```
The image is built on the [csdms/grpc4bmi](https://hub.docker.com/r/csdms/grpc4bmi) base image,
which is built on the [condaforge/miniforge3](https://hub.docker.com/r/condaforge/miniforge3) base image.
The OS is Linux/Ubuntu.
The C++ BMI example, grpc4bmi, and the grpc4bmi server are installed in `/opt/conda`.

## Run

Use the grpc4bmi Docker client to access the BMI methods of the containerized model.

Install with *pip*:
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
(e.g., try the `csdms/bmi-example-cxx-grpc4bmi` image).

For more in-depth examples of running the *Heat* model through grpc4bmi,
see the [examples](./examples) directory.

## Developer notes

A versioned, multiplatform image built from the *conda-base* image in this repository is hosted on Docker Hub
at [csdms/bmi-example-cxx-grpc4bmi](https://hub.docker.com/r/csdms/bmi-example-cxx-grpc4bmi).
This image is automatically built and pushed to Docker Hub
with the [release](./.github/workflows/release.yml) CI workflow.
The workflow is only run when the repository is tagged.
To manually build and push an update, run:
```
docker buildx build --platform linux/amd64,linux/arm64 -t csdms/bmi-example-cxx-grpc4bmi:latest --push .
```
A user can pull this image from Docker Hub with:
```
docker pull csdms/bmi-example-cxx-grpc4bmi
```
optionally with the `latest` tag or with a version tag.

## Acknowledgment

This work is supported by the U.S. National Science Foundation under Award No. [2103878](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2103878), *Frameworks: Collaborative Research: Integrative Cyberinfrastructure for Next-Generation Modeling Science*.
