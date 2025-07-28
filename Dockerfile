# A grpc4bmi server for the `HeatCxx` model from bmi-example-cxx.
FROM csdms/grpc4bmi:0.1.0

LABEL org.opencontainers.image.authors="Mark Piper <mark.piper@colorado.edu>"
LABEL org.opencontainers.image.source="https://github.com/csdms/bmi-example-cxx-grpc4bmi"

WORKDIR ${CONDA_DIR}
COPY --from=csdms/bmi-examples:0.1.0 ${CONDA_DIR}/bin/run_bmiheatcxx bin/run_bmiheatcxx
COPY --from=csdms/bmi-examples:0.1.0 ${CONDA_DIR}/lib/libheatcxx.so lib/libheatcxx.so
COPY --from=csdms/bmi-examples:0.1.0 ${CONDA_DIR}/lib/libbmiheatcxx.so lib/libbmiheatcxx.so
COPY --from=csdms/bmi-examples:0.1.0 ${CONDA_DIR}/include/bmi_heat.hxx include/bmi_heat.hxx
COPY --from=csdms/bmi-examples:0.1.0 ${CONDA_DIR}/include/heat.hxx include/heat.hxx
COPY --from=csdms/bmi-examples:0.1.0 ${CONDA_DIR}/lib/pkgconfig/heatcxx.pc lib/pkgconfig/heatcxx.pc
COPY --from=csdms/bmi-examples:0.1.0 ${CONDA_DIR}/lib/pkgconfig/bmiheatcxx.pc lib/pkgconfig/bmiheatcxx.pc

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
