FROM container-registry.oracle.com/database/free:23.4.0.0-lite
RUN mkdir -p /opt/oracle/scripts/startup/co/
COPY ./customer_orders/co_install.sql /opt/oracle/scripts/startup/01.sql
COPY ./customer_orders/co_create.sql /opt/oracle/scripts/startup/co/co_create.sql
COPY ./customer_orders/co_populate.sql /opt/oracle/scripts/startup/co/co_populate.sql
