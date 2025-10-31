FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create a non-root user
RUN addgroup -g 1001 -S movieservice && \
    adduser -S movieservice -u 1001 -G movieservice

# Copy the jar file
COPY target/movie-service-*.jar app.jar

# Change ownership of the app
RUN chown movieservice:movieservice app.jar

# Switch to non-root user
USER movieservice

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8081/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]