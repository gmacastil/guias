FROM openjdk:21-jdk

WORKDIR /app
COPY target/*.jar micro.jar

ENV JAVA_OPTS=""

CMD java $JAVA_OPTS -jar /app/micro.jar

