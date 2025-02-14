.PHONY: haskell, pull-haskell, venv, serve

HASKELL_TAG=20230416041647af37a0
PYTHON=python3.12
NB_PORT = 8888
VENV_PATH = ./.venv
VENV_BIN=$(VENV_PATH)/bin
PYBIN=$(VENV_BIN)/python
NIKOLA=$(VENV_BIN)/nikola


markdown:
	$(NIKOLA) new_post --format=markdown

init: venv
	$(PYBIN)/python -m pip install -r requirements.txt

venv: clean
	$(PYTHON) -m venv $(VENV_PATH) && $(PYBIN) -m pip install --upgrade pip


jupyter:
	$(PYBIN)/jupyter notebook

haskell: pull-haskell
	docker run -ti --rm -p $(NB_PORT):8888 -v $${PWD}:/home/jovyan/src gibiansky/ihaskell:$(HASKELL_TAG)

pull-haskell:
	docker pull gibiansky/ihaskell:$(HASKELL_TAG)

clean:
	rm -rf $(VENV_PATH)

build:
	$(NIKOLA) build

serve:
	$(NIKOLA) serve --browser

deploy:
	$(NIKOLA) github_deploy