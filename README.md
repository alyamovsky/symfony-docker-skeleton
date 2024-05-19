# Symfony w/ Docker config

[![Latest Stable Version](https://poser.pugx.org/alyamovsky/symfony-docker-skeleton/version.svg)](https://packagist.org/packages/alyamovsky/symfony-docker-skeleton)

A project template in the following configuration:
1. Latest stable Symfony framework (6.4 at the moment)
2. PHP 8.3
3. PostgreSQL 16.3 (can be altered in the docker-compose file) ?
4. Separate Docker containers for Nginx, FPM, CLI and a database
5. CS-Fixer and Psalm on board

# The concept

1. The application and docker files are located on the same level: in the `/app` and `/docker` folders, respectively. 
   This allows you to separate the symphony-application and docker environment variables, and to implement the mono 
   repository pattern by adding new folders if necessary: `/centrifugo`, `s3-storage`, etc.
2. The `docker-compose.override.yaml` is ignored by default, so you can add your own settings without worrying about 
   overwriting the original ones.

# Quick Start
One-liner to create a new project: `composer create-project ddlzz/symfony-docker-website-skeleton local_project_path && make setup-configs && make init OPTIONS="webapp" && make up`

Split into steps:
1. `composer create-project ddlzz/symfony-docker-website-skeleton local_project_path`
2. `make setup-configs` - create .env files for docker containers
3. `make init OPTIONS="webapp"` - very important! Run it before making any commits to your repo. You can omit the `OPTIONS` parameter if you don't need to use the webapp.
4. `make up` - start docker containers 

Default ports are random (47001-47999) for every created project, so click the link generated in CLI with the output of `make up` command and enjoy!

You also can set desired ports for Nginx and PostgreSQL manually in generated /.env file (don't forget to run `make restart` afterwards).

## Configuring Xdebug settings for PhpStorm IDE

To integrate Xdebug with PhpStorm within a created project you need to do the following:
1. Create a PHP interpreter in the `Settings -> Languages & Frameworks -> PHP` tab from the php-fpm container in the project; make sure that Xdebug works properly in the container.
2. Type the port number `9009` at the menu `Settings -> Languages & Frameworks -> PHP -> Debug -> Xdebug -> Debug`.
3. Create a server named `Docker` in the menu `Settings -> Languages & Frameworks -> PHP -> Servers` (it matches with the value of the `ServerName` field in the IDE config for both interpreters).
4. If necessary, make proper mappings in the PHP interpreter `Settings -> Languages & Frameworks -> PHP -> Path Mappings`,
5. Click the button `Listen for PHP debug connections`; if you have any questions, please read the [documentation](https://www.jetbrains.com/help/phpstorm/debugging-with-phpstorm-ultimate-guide.html).

# Useful makefile commands

1. `make console` - default shell is zsh with preinstalled set of [plugins](https://github.com/alyamovsky/symfony-docker-website-skeleton/blob/main/docker/configs/dev/php-cli/.zshrc)
2. `make test` - PHPUnit tests
3. `make cs` - PHP CS-fixer with predefined [rule sets](https://github.com/alyamovsky/symfony-docker-website-skeleton/blob/main/app/.php_cs.dist) 
4. `make psalm` - Psalm (default level is 1)

