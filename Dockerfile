# Use the official Node.js image as the base
FROM node:16

# Install Swift
RUN apt-get update && apt-get install -y swift

# Verify Swift installation
RUN swift --version

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json into the container
COPY package.json package-lock.json ./

# Install dependencies using npm
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
