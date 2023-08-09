MODULE      := svg_plot
MODULE_VERS := 0.1.1
MODULE_DEPS := \
		setup.cfg \
		setup.py \
		svg_plot/*.py

FLAKE_MODULES := svg_plot
LINT_MODULES  := svg_plot

.PHONY: all
all: $(MODULE)

.PHONY: clean
clean:
	rm -rf dist *.egg-info build
	find . -name "*.pyc" | xargs rm
	find . -name __pycache__ | xargs rm -r

.PHONY: test
test: flake8 lint
	python3 ./tests/step_test.py

.PHONY: flake8
flake8:
	python3 -m flake8 $(FLAKE_MODULES)

.PHONY: lint
lint:
	pylint --exit-zero $(LINT_MODULES)

.PHONY: $(MODULE)
$(MODULE): dist/$(MODULE)-$(MODULE_VERS)-py3-none-any.whl

.PHONY: install
install: $(MODULE)
	sudo pip3 uninstall -y $(MODULE)
	sudo pip3 install dist/$(MODULE)-$(MODULE_VERS)-py3-none-any.whl

.PHONY: uninstall
uninstall:
	sudo pip3 uninstall $(MODULE)

dist/$(MODULE)-$(MODULE_VERS)-py3-none-any.whl: $(MODULE_DEPS) Makefile
	python3 setup.py --quiet sdist bdist_wheel
	python3 -m twine check $@
