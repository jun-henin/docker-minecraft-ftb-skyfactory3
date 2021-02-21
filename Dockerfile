# This Docker file builds a basic minecraft server
# directly from the default minecraft server from Mojang
#
#FROM ubuntu:20.04
#FROM java:8
FROM openjdk:8 AS build

#-------------------------------------
ENV SERVER_MESSAGE="FTB SkyFactory 3"
ENV MODE_ID=25
ENV VERSION_ID=123
ENV VERSION_NAME=3.0.21
#-------------------------------------


ENV VERSION="${VERSION_NAME} (${MODE_ID}/${VERSION_ID})"
MAINTAINER jhe “jun.henin.biz@gmail.com”
RUN apt-get update
RUN apt-get install -y default-jdk
RUN apt-get install -y wget unzip

#RUN addgroup --gid 1234 minecraft
#RUN adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft
#USER minecraft

#RUN mkdir minecraft
RUN mkdir /tmp/feed-the-beast 

# Download zip server file from https://www.curseforge.com/minecraft/modpacks/ftb-presents-skyfactory-3/files
#COPY FTB_Presents_SkyFactory_3_Server_${VERSION}.zip /tmp/feed-the-beast/FTBServer.zip

RUN cd /tmp/feed-the-beast &&\
  wget -c https://api.modpacks.ch/public/modpack/${MODE_ID}/${VERSION_ID}/server/linux -O FTBServerInstall_${MODE_ID}_${VERSION_ID} &&\
  #wget -c https://www.shop-from-japan.com/minecraft/FTB_Presents_SkyFactory_3_Server_3_0_21.zip -O FTBServer.zip &&\
  #cp /FTB_Presents_SkyFactory_3_Server_3_0_21.zip FTBSkyfactoryServer.zip &&\
  chmod +x ./FTBServerInstall_${MODE_ID}_${VERSION_ID} && \
  ./FTBServerInstall_${MODE_ID}_${VERSION_ID} --auto && \
  rm FTBServerInstall_${MODE_ID}_${VERSION_ID}  
  #bash -x Install.sh
# && \
#  chown -R minecraft /tmp/feed-the-beast

#USER minecraft

EXPOSE 25565

ADD start.sh /start

#VOLUME /data
ADD server.properties /tmp/server.properties
#WORKDIR /data

CMD /start

ENV MOTD ${SERVER_MESSAGE} ${VERSION} Server Powered by (jhe) Docker
ENV LEVEL world
ENV JVM_OPTS -Xms2048m -Xmx2048m

RUN echo "eula=true" > eula.txt

#CMD java -Xms2048m -Xmx2048m -jar /tmp/feed-the-beast/FTBserver-*.jar nogui

#RUN cd /tmp/feed-the-beast && bash -x ServerStart.sh
