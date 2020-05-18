help:
	@egrep "^#" Makefile

# dr|docker-run
dr: docker-run
docker-run: 
	docker run -v $(PWD):/app ace-no-medic 

# ba|bash-app
ba: bash-app
bash-app:
	docker-compose run --rm app bash

# db|docker-build
db: docker-build
docker-build:
	docker build . -t ace-no-medic
