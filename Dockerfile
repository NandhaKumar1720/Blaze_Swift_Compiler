# Use Ubuntu as base since Swift is not included in the Node.js image
FROM ubuntu:20.04

# Set non-interactive mode to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    clang \
    libicu-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and install Swift
RUN curl -s https://download.swift.org/swift-5.7-release/ubuntu2004/swift-5.7-RELEASE/swift-5.7-RELEASE-ubuntu20.04.tar.gz \
    -o swift.tar.gz && \
    tar -xzf swift.tar.gz && \
    mv swift-5.7-RELEASE-ubuntu20.04 /usr/local/swift && \
    rm swift.tar.gz

# Set Swift environment variables
ENV PATH="/usr/local/swift/usr/bin:${PATH}"

# Install Node.js
RUN apt-get update && apt-get install -y nodejs npm

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Expose the port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
