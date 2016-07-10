.PHONY: all test doc

all: test doc

test:
	cram --indent=3 README.rst
	pip freeze -r requirements.txt > pinned-requirements.txt

doc:
	$(MAKE) -C doc html
