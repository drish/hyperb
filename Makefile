.PHONY: test

build:
	docker build -t hyperb .

test:
	docker run --rm -v $(PWD):/usr/src hyperb bundle exec rake spec

pry:
	docker run --rm -it -v $(PWD):/usr/src hyperb bundle exec pry

rake:
	docker run --rm -it -v $(PWD):/usr/src hyperb bundle exec rake

rubocop:
	docker run --rm -it -v $(PWD):/usr/src hyperb bundle exec rake rubocop