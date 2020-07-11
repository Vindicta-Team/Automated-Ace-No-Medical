help:
	@egrep "^#" Makefile

# db|docker-build	- Build docker image (need credentials setup)
db: docker-build
docker-build:
	docker-compose up -d --build

# ba|bash-app		- Connect shell into container
ba: bash-app
bash-app:
	docker-compose run --rm app bash

# run				- Run python script in container
run:
	docker-compose run --rm app sh -c "python3 main.py"
