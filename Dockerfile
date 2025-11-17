# ===== STAGE 1: Build the application =====
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies first (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code & build jar
COPY src ./src
RUN mvn clean package -DskipTests

# ===== STAGE 2: Run the application =====
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the jar from builder stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
