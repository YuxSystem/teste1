# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory in the container
WORKDIR .

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./run.sh"]
