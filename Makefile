help:
	@egrep "^#" Makefile

# db|docker-build
db: docker-build
docker-build:
	docker-compose up -d --build

# ba|bash-app
ba: bash-app
bash-app:
	docker-compose run --rm app bash

# run
run:
	docker-compose run --rm app sh -c "python3 main.py"
