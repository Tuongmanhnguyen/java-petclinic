# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
# Copy the maven wrapper and pom file first to leverage Docker cache
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
# Copy source and build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the production image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# Create a non-root user for security
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring
# Copy only the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar
# Expose the port
EXPOSE 8080
# Run the application with the MySQL profile
ENTRYPOINT ["java", "-Dspring.profiles.active=mysql", "-jar", "app.jar"]