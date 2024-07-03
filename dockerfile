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
WORKDIR /home/azureuser

# Set permissions for the azureuser
RUN chgrp -R 0 /home/azureuser && \
    chmod -R g=u /home/azureuser

# Copy the jar file from the build stage
COPY --from=builder /app/gameoflife-web/target/gameoflife.war /home/azureuser

# Expose the application port
EXPOSE 8080

# Change to the azureuser
USER azureuser

# Run the application
CMD ["java", "-jar", "/home/azureuser/target/*.war"]
