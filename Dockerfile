# Build stage
FROM maven:3.9-eclipse-temurin-17-focal AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-focal

WORKDIR /app

# Copy the built artifact from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the port your application runs on
EXPOSE 8095

# Set environment variables that Render expects
ENV SPRING_PROFILES_ACTIVE=prod
ENV PORT=8095

# Create a non-root user
RUN useradd -m myuser
USER myuser

# Command to run the application
CMD ["java", "-jar", "-Dserver.port=$PORT", "app.jar"]