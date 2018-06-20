.PHONY: build

build:
	stack build

rebuild:
	stack exec rbio rebuild

deploy:
	sh script/deploy
