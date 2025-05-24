# Use the official Node.js LTS image as the base
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files separately for caching npm install
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Expose application port (change if your app uses a different port)
EXPOSE 3000

# Start the application
CMD ["node", "index.js"]
