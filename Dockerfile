#############################################
# Etapa 1: Build con Maven + Eclipse Temurin JDK 21
#############################################
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# 1) Copiar pom.xml y código fuente
COPY pom.xml .
COPY src/ src/

# 2) Empaquetar sin tests
RUN mvn clean package -DskipTests

#############################################
# Etapa 2: Runtime con OpenJDK 21 Slim
#############################################
FROM openjdk:21-slim
WORKDIR /app

# 3) Copiar el JAR compilado
COPY --from=builder /app/target/*.jar ./discovery-server.jar

# 4) Exponer el puerto 8761 (documentativo; Railway inyecta PORT)
EXPOSE 8761

# 5) Ejecutar el JAR
ENTRYPOINT ["java", "-jar", "discovery-server.jar"]
