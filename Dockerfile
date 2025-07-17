# grpc4bmi server for `HeatCxx` model from bmi-example-cxx.
FROM csdms/grpc4bmi

LABEL maintainer="Mark Piper <mark.piper@colorado.edu>"

RUN git clone --branch v2.1.2 --depth 1 https://github.com/csdms/bmi-example-cxx /opt/bmi-example-cxx
WORKDIR /opt/bmi-example-cxx/_build
RUN cmake .. && \
    make && \
    make test && \
    make install && \
    make clean

# Build the grpc4bmi server for the `heatcxx` model.
COPY server /opt/heatcxx-grpc4bmi-server
WORKDIR /opt/heatcxx-grpc4bmi-server/_build
RUN cmake .. && \
    make && \
    make install && \
    make clean

WORKDIR /opt

ENTRYPOINT ["/usr/local/bin/heatcxx-grpc4bmi-server"]
EXPOSE 55555
