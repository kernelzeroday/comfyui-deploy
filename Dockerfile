FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    openssl \
    git

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
# Install bun
RUN npm install -g bun

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Install project dependencies
RUN cd web && bun install

# Copy environment file
RUN cp .env.example .env.local

# Replace JWT_SECRET
RUN echo JWT_SECRET=$(openssl rand -hex 32) >> .env.local

# Run migrations and start server
CMD bun run db-dev & bun run migrate-local && bun dev
