ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Run this command after `make setup-configs` to set up the project
init: setup-configs app-install db-create db-migrations permissions-fix cleanup

up: docker-up
down: docker-down
restart: down up
rebuild: down docker-build
reset: rebuild up

docker-up:
	docker compose -p $(DOCKER_PROJECT_TITLE) up -d
	@echo ***Success! Your app is ready and available at http://localhost:$(DOCKER_NGINX_PORT) and you can connect PostgreSQL from your host machine on port $(DOCKER_POSTGRESQL_PORT).***

docker-down:
	docker compose -p $(DOCKER_PROJECT_TITLE) down --remove-orphans

docker-remove:
	docker compose -p $(DOCKER_PROJECT_TITLE) down --rmi all -v

docker-down-clear:
	docker compose -p $(DOCKER_PROJECT_TITLE) down -v --remove-orphans

docker-pull:
	docker compose -p $(DOCKER_PROJECT_TITLE) pull

docker-build:
	docker compose -p $(DOCKER_PROJECT_TITLE) build

test:
	docker compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli php /app/bin/phpunit

app-install:
	VERSION=$(VERSION) ./build/scripts/install-app.sh $(OPTIONS) || true # install the Symfony app itself

console:
	docker compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli zsh

cs:
	docker compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/vendor/bin/php-cs-fixer -v --allow-risky=yes fix"

psalm:
	docker compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/vendor/bin/psalm /app/src/*"

db-create:
	docker compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/bin/console doctrine:database:create --if-not-exists"

db-migrations:
	docker compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "php /app/bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration"

permissions-fix:
	docker compose -p $(DOCKER_PROJECT_TITLE) run --rm php-cli sh -c "chmod -R u+rwX,g+w,go+rX,o-w .; [ -d ./var/log ] && chmod -R 777 ./var/log; [ -d ./var/cache ] && chmod -R 777 ./var/cache; chmod -R o+rX ./public"

setup-configs:
	[ -f compose.override.yaml ] && echo "Skip compose.override.yaml" || cp compose.override.yaml.dist compose.override.yaml
	./build/scripts/override-default-docker-env-vars.sh || true # Set random project title and host ports for Nginx/PostgreSQL
	[ -f ./.env ] && echo "Skip docker .env" || cp ./.env.dist ./.env

cleanup:
	rm -rf ./vendor composer.json composer.lock RUN_MAKE_INIT_COMMAND_PLEASE.md || true
	rm -rf ./build || true

prepare-commit-msg:
	[ -d ./.git/hooks ] && echo "./.git/hooks exists" || mkdir -p .git/hooks
	[ -f .git/hooks/prepare-commit-msg ] && echo "Skip .hooks/prepare-commit-msg" || cp docker/configs/dev/hooks/prepare-commit-msg .git/hooks/prepare-commit-msg && chmod +x .git/hooks/prepare-commit-msg
