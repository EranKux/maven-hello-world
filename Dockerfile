# --- Multistage Docker Build ---
# The Maven stage builds the JAR from source.
# The runtime stage copies the JAR to a minimal OpenJDK image, running as a non-root user.
# This enables building, packaging, and running your app with a single Docker build command, covering most of the requested pipeline steps.

# --- Build Stage ---
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /build
COPY myapp/pom.xml myapp/pom.xml
COPY myapp/src myapp/src
RUN mvn -f myapp/pom.xml clean package

# --- Runtime Stage ---
FROM eclipse-temurin:17-jdk-jammy
RUN useradd -m appuser
USER appuser
WORKDIR /home/appuser
COPY --from=build /build/myapp/target/myapp-*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
