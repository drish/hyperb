.PHONY: test

build:
	docker build -t hyperb .

test:
	docker run --rm -v $(PWD):/usr/src hyperb bundle exec rspec spec

pry:
	docker run --rm -it -v $(PWD):/usr/src hyperb bundle exec pry
