ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Run this command after `make configs-setup` to set up the project
init: composer-install db-create db-migrations permissions-fix

up: docker-up
down: docker-down
restart: down up
rebuild: down docker-build
reset: rebuild up

docker-up:
	docker-compose -p $(DOCKER_PROJECT_TITLE) up -d
	@echo ***Success! Your app is ready and available at http://localhost:$(DOCKER_NGINX_PORT) and you can connect PostgreSQL from your host machine on port $(DOCKER_POSTGRESQL_PORT).***

docker-down:
	docker-compose -p $(DOCKER_PROJECT_TITLE) down --remove-orphans

docker-down-clear:
	docker-compose -p $(DOCKER_PROJECT_TITLE) down -v --remove-orphans

docker-pull:
	docker-compose -p $(DOCKER_PROJECT_TITLE) pull

docker-build:
	docker-compose -p $(DOCKER_PROJECT_TITLE) build

test:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli php /app/bin/phpunit

composer-install:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "umask 002 && composer install --no-interaction"

console:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli zsh

cs:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/vendor/bin/php-cs-fixer -v --allow-risky=yes --config=/app/.php_cs.dist fix /app/src/* /app/tests/*"

psalm:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/vendor/bin/psalm /app/src/*"

db-create:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/bin/console doctrine:database:create --if-not-exists"

db-migrations:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration"

permissions-fix:
	docker-compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "chmod -R u+rwX,g+w,go+rX,o-w .; [ -d ./var/log ] && chmod -R 777 ./var/log; [ -d ./var/cache ] && chmod -R 777 ./var/cache; chmod -R o+rX ./public"

configs-setup:
	rm -r ./vendor composer.json composer.lock RUN_MAKE_INIT_COMMAND_PLEASE.md || true # Remove template root composer files, keep only the ./app ones
	[ -f docker-compose.override.yaml ] && echo "Skip docker-compose.override.yaml" || cp docker-compose.override.yaml.dist docker-compose.override.yaml
	[ -f ./app/.env.local ] && echo "Skip .env.local" || cp ./app/.env ./app/.env.local
	./build-scripts/override-default-docker-env-vars.sh || true # Set random project title and host ports for Nginx/PostgreSQL
	rm -r ./build-scripts || true
	[ -f ./.env ] && echo "Skip docker .env" || cp ./.env.dist ./.env
	[ -f ./app/phpunit.xml ] && echo "Skip phpunit.xml" || cp ./app/phpunit.xml.dist ./app/phpunit.xml
	[ -d ./app/var/data/.composer ] && echo "./var/data/.composer exists" || mkdir -p ./app/var/data/.composer
	[ -f ./app/var/data/.composer/auth.json ] && echo "Skip ./var/data/.composer/auth.json" || echo '{}' > ./app/var/data/.composer/auth.json

prepare-commit-msg:
	[ -d ./.git/hooks ] && echo "./.git/hooks exists" || mkdir -p .git/hooks
	[ -f .git/hooks/prepare-commit-msg ] && echo "Skip .hooks/prepare-commit-msg" || cp docker/dev/hooks/prepare-commit-msg .git/hooks/prepare-commit-msg && chmod +x .git/hooks/prepare-commit-msg
