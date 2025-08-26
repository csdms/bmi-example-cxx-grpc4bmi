# A grpc4bmi server for the bmi-example-cxx `Heat` model.
FROM csdms/grpc4bmi:0.3.0

LABEL org.opencontainers.image.authors="Mark Piper <mark.piper@colorado.edu>"
LABEL org.opencontainers.image.source="https://github.com/csdms/bmi-example-cxx-grpc4bmi"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/csdms/bmi-example-cxx-grpc4bmi"
LABEL org.opencontainers.image.vendor="CSDMS"

COPY server /opt/heatcxx-grpc4bmi-server
WORKDIR /opt/heatcxx-grpc4bmi-server/_build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=${CONDA_DIR} && \
    make && \
    make install && \
    make clean

WORKDIR /opt

ENTRYPOINT ["/opt/conda/bin/heatcxx-grpc4bmi-server"]
EXPOSE 55555
