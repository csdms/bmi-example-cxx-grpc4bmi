# A grpc4bmi server for the bmi-example-cxx `Heat` model.
FROM mdpiper/grpc4bmi

LABEL maintainer="Mark Piper <mark.piper@colorado.edu>"

RUN git clone --branch v2.1.3 --depth 1 https://github.com/csdms/bmi-example-cxx /opt/bmi-example-cxx
WORKDIR /opt/bmi-example-cxx/_build
RUN cmake .. && \
    make && \
    make test && \
    make install && \
    make clean

COPY server /opt/heatcxx-grpc4bmi-server
WORKDIR /opt/heatcxx-grpc4bmi-server/_build
RUN cmake .. && \
    make && \
    make install && \
    make clean

RUN ldconfig

WORKDIR /opt

ENTRYPOINT ["/usr/local/bin/heatcxx-grpc4bmi-server"]
EXPOSE 55555
