#!/bin/bash

echo "Starting cleanup process..."

# Stop and remove containers
echo "Stopping MySQL container..."
docker compose down

# Remove volumes (this will delete all data)
echo "Removing MySQL data volumes..."
docker compose down -v

# Remove unused networks
echo "Cleaning up unused networks..."
docker network prune -f

# Remove unused images (optional)
read -p "Do you want to remove MySQL images as well? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing MySQL images..."
    docker image rm mysql:8.0 2>/dev/null || echo "MySQL image not found or already removed"
fi

echo "Cleanup completed!"
echo "All containers, volumes, and networks have been removed."
echo "To start fresh, run: docker compose up -d"