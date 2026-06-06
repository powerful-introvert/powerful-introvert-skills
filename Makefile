.PHONY: all validate dist clean test

all: validate dist

validate:
	@bash scripts/validate.sh .

dist: validate
	@bash scripts/dist.sh .

test:
	@bash tests/run_tests.sh

clean:
	rm -rf dist/
