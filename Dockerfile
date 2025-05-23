# First stage: Build the Java application
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests

# Second stage: Run the application
FROM eclipse-temurin:17-jre

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

RUN useradd -m appuser
USER appuser

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
