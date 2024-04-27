#!/bin/bash

# Run Sequelize migrations
npm run db:migrate

# Run Sequelize seeds
npm run db:seed

# Start the application
node dist/server.js
