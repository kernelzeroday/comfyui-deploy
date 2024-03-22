FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    openssl \
    git

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Set up nvm environment variables
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 20.11.1

# Install specific Node version and set it as default
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION"

# Update PATH
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install yarn
RUN npm install --global yarn

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Install project dependencies
RUN yarn install

# Copy environment file
RUN find / -name ".env.example" -exec cp {} .env \;
# Replace JWT_SECRET
RUN echo JWT_SECRET=$(openssl rand -hex 32) >> .env.local

# Run migrations and start server
CMD yarn dev
