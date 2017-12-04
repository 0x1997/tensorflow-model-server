FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=:/etc/localtime

RUN ln -sf /usr/share/zoneinfo/PRC /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb [arch=amd64] http://storage.googleapis.com/tensorflow-serving-apt stable tensorflow-model-server tensorflow-model-server-universal" \
     | tee /etc/apt/sources.list.d/tensorflow-serving.list \
    && curl https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends tensorflow-model-server \
    && apt-get purge -y --auto-remove curl ca-certificates gnupg \
    && rm -rf /var/lib/apt/lists/*

VOLUME /mnt
WORKDIR /mnt
ENTRYPOINT ["tensorflow_model_server"]
