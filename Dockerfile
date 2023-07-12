FROM ubuntu:22.04 AS sudachi
RUN apt-get update && apt-get install -y wget unzip
RUN wget http://sudachi.s3-website-ap-northeast-1.amazonaws.com/sudachidict/sudachi-dictionary-20230110-full.zip && \
    unzip sudachi-dictionary-20230110-full.zip && \
    mv sudachi-dictionary-20230110/system_full.dic /opt/system_full.dic

FROM elasticsearch:8.6.0

RUN elasticsearch-plugin install https://github.com/WorksApplications/elasticsearch-sudachi/releases/download/v3.0.0/analysis-sudachi-8.6.0-3.0.0.zip

COPY --chown=root:elasticsearch --from=sudachi /opt/system_full.dic /etc/elasticsearch/system_full.dic
COPY --chown=root:elasticsearch sudachi.json /etc/elasticsearch/
