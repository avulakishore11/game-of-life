# Base image to build and publish the artifact
FROM maven:3.9.8-eclipse-temurin-8 AS builder

# Set up the working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Build the actual application
RUN mvn clean package

# Stage 2: Create the runtime image
FROM eclipse-temurin:8-jre

# Set the working directory
WORKDIR /app

# Copy the war file from the build stage
COPY --from=builder /app/gameoflife-web/target/gameoflife.war .

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "gameoflife.war"]
