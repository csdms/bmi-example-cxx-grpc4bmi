# A grpc4bmi server for the `HeatCxx` model from bmi-example-cxx.
FROM csdms/grpc4bmi:0.1.0

LABEL maintainer="Mark Piper <mark.piper@colorado.edu>"

RUN git clone --branch v2.1.3 --depth 1 https://github.com/csdms/bmi-example-cxx /opt/bmi-example-cxx
WORKDIR /opt/bmi-example-cxx/_build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=${CONDA_DIR} && \
    make && \
    make test && \
    make install && \
    make clean

# Build the grpc4bmi server for the `heatcxx` model.
COPY server /opt/heatcxx-grpc4bmi-server
WORKDIR /opt/heatcxx-grpc4bmi-server/_build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=${CONDA_DIR} && \
    make && \
    make install && \
    make clean

WORKDIR /opt

ENTRYPOINT ["/opt/conda/bin/heatcxx-grpc4bmi-server"]
EXPOSE 55555
