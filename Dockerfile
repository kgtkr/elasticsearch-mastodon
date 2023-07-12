FROM ubuntu:22.04 AS sudachi
RUN apt-get update && apt-get install -y wget unzip git
RUN wget http://sudachi.s3-website-ap-northeast-1.amazonaws.com/sudachidict/sudachi-dictionary-20230110-full.zip && \
    unzip sudachi-dictionary-20230110-full.zip && \
    mv sudachi-dictionary-20230110/system_full.dic /opt/system_full.dic

RUN git clone https://github.com/WorksApplications/Sudachi.git /opt/Sudachi && \
    cd /opt/Sudachi && git checkout v0.7.3


FROM docker.elastic.co/elasticsearch/elasticsearch:7.10.2

RUN elasticsearch-plugin install https://github.com/WorksApplications/elasticsearch-sudachi/releases/download/v3.1.0/analysis-sudachi-7.10.2-3.1.0.zip

RUN mkdir -p /usr/share/elasticsearch/config/sudachi/
COPY --chown=root:elasticsearch --from=sudachi /opt/Sudachi/src/main/resources/* /usr/share/elasticsearch/config/sudachi/
COPY --chown=root:elasticsearch --from=sudachi /opt/system_full.dic /usr/share/elasticsearch/config/sudachi/
COPY --chown=root:elasticsearch sudachi.json /usr/share/elasticsearch/config/sudachi/
