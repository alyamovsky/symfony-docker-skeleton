# Symfony5 w/ Docker config

A project template in the following configuration:
1. Symfony5
2. PHP8
3. PostgreSQL 13.2
4. Separate Docker containers for Nginx, FPM, CLI and a database
5. CS-Fixer and Psalm on board

# Quick Start

1. `composer create-project ddlzz/symfony5-docker-website-skeleton local_project_path`
2. `make init`
3. `make up`
4. Type `https://localhost:47083` in your browser and enjoy!