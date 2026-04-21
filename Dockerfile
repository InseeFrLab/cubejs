FROM cubejs/cube:v1.6.37

COPY --chmod=0755 scripts/ /opt/

RUN /opt/install-system-libs.sh && \ 
    /opt/install-duckdb-cli.sh && \
    /opt/fix-ownership.sh 
USER 1000

RUN /opt/install-duckdb-extensions.sh
