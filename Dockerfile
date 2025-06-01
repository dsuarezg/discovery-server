#############################################
# Etapa 1: Build (Maven + OpenJDK 21)
#############################################
FROM maven:3.9.6-openjdk-21 AS builder

WORKDIR /app
COPY pom.xml ./
COPY src/ ./src/
RUN mvn clean package -DskipTests

#############################################
# Etapa 2: Runtime (OpenJDK 21)
#############################################
FROM openjdk:21-jdk-slim

WORKDIR /app
COPY --from=builder /app/target/*.jar ./discovery-server.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "discovery-server.jar"]