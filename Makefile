.PHONY: up
up:
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose stop

.PHONY: restart
restart:
	@make stop
	@make up

.PHONY: down
down:
	docker-compose down

.PHONY: destroy
destroy:
	docker-compose down --rmi all --volumes

.PHONY: install
install:
	docker-compose up -d --build
	@make composer-install
	@make npm-install
	@make restart
	@make migrate
	@echo Install ${APP_NAME} successfully finished!

.PHONY: reinstall
reinstall:
	@make destroy
	@make install

.PHONY: node
node:
	docker-compose exec node sh

.PHONY: composer-install
composer-install:
	docker-compose run --rm app bash -c 'composer install'

.PHONY: npm-install
npm-install:
	docker-compose exec node sh -c 'npm install'

.PHONY: migrate
migrate:
	docker-compose run --rm app php artisan migrate

.PHONY: seed
seed:
	docker-compose run --rm app php artisan db:seed

.PHONY: setup-db
setup-db:
	make migrate
	make seed

.PHONY: db-fresh
db-fresh:
	docker-compose run --rm app php artisan migrate:fresh --seed

.PHONY: db-fresh-sample
db-fresh-sample:
	docker-compose run --rm app composer dump-autoload
	docker-compose run --rm app php artisan migrate:fresh
	docker-compose run --rm app php artisan db:seed --class=SampleSeeder
