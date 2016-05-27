.PHONY: test

test:
	cram --indent=3 README.rst
	pip freeze -r requirements.txt > pinned-requirements.txt
