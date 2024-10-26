FROM openjdk:17-oracle
COPY ./target/EurekaRegistry-0.0.1-SNAPSHOT.jar EurekaRegistry.jar
CMD ["java","-jar","EurekaRegistry.jar"]