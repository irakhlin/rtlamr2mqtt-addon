ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data
COPY data/run.sh /

RUN chmod +x /run.sh

CMD [ "/run.sh" ]