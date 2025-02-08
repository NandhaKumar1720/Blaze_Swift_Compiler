# Use Ubuntu as the base image
FROM ubuntu:latest

# Install required dependencies
RUN apt-get update && apt-get install -y \
    clang \
    libicu-dev \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Swift
RUN wget https://download.swift.org/swift-5.7-release/ubuntu2204/swift-5.7-RELEASE/swift-5.7-RELEASE-ubuntu22.04.tar.gz \
    && tar -xvzf swift-5.7-RELEASE-ubuntu22.04.tar.gz \
    && mv swift-5.7-RELEASE-ubuntu22.04 /usr/local/swift \
    && rm swift-5.7-RELEASE-ubuntu22.04.tar.gz

# Set Swift environment variables
ENV PATH="/usr/local/swift/usr/bin:$PATH"

RUN swift --version

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy project files
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
