FROM nginx:latest

RUN apt-get update && apt-get install -y curl

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Health check script
COPY nginx/healthcheck /usr/local/bin/healthcheck
RUN chmod +x /usr/local/bin/healthcheck

WORKDIR /etc/nginx

# Set the default command to execute when creating a new container
CMD ["nginx", "-g", "daemon off;"]