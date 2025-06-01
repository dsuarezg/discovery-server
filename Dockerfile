#############################################
# Etapa 1: Build (Maven + Temurin JDK 21)
#############################################
FROM maven:3.9.3-eclipse-temurin-21-alpine AS builder

# Establecer el directorio de trabajo
WORKDIR /app

# 1) Copiamos pom.xml y código fuente
COPY pom.xml ./
COPY src/ ./src/

# 2) Empaquetar sin tests
RUN mvn clean package -DskipTests

#############################################
# Etapa 2: Runtime (Temurin JRE 21)
#############################################
FROM eclipse-temurin:21-jre-alpine

# Directorio de trabajo en la imagen resultante
WORKDIR /app

# Copiar el JAR generado en la etapa de build
COPY --from=builder /app/target/*.jar ./discovery-server.jar

# Exponer el puerto 8761 (documentativo; Railway inyectará dinámicamente)
EXPOSE 8761

# Comando por defecto al iniciar el contenedor
ENTRYPOINT ["java", "-jar", "discovery-server.jar"]
