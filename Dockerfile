FROM maximhq/bifrost:v2.6.0

# Switch to root to place config and set permissions
USER root

WORKDIR /app
COPY config.json /app/data/config.json

# Ensure non-root container user (1000) owns /app/data
RUN chown -R 1000:1000 /app/data

# Switch back to default container user
USER 1000

# Expose default HTTP gateway port
EXPOSE 8080

# Configure defaults for Bifrost runtime
ENV APP_HOST=0.0.0.0
ENV APP_PORT=8080
ENV APP_DIR=/app/data
ENV LOG_LEVEL=info
ENV LOG_STYLE=json

# Keep the Go heap under Render free tier's 512 MB (about 80%)
ENV GOMEMLIMIT=400MiB