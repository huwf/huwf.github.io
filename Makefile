.PHONY: haskell, pull-haskell, venv

HASKELL_TAG=20230416041647af37a0
PYTHON_VERSION=3.10
NB_PORT = 8888
VENV=nikola
ANACONDA=$${HOME}/anaconda3
CONDA=$(ANACONDA)/bin/conda
PYBIN=$(ANACONDA)/envs/$(VENV)/bin
PYVENV=${PWD}
NIKOLA=$(ANACONDA)/envs/$(VENV)/bin/nikola


markdown:
	$(NIKOLA) new_post --format=markdown

init: venv
	$(PYBIN)/python -m pip install -r requirements.txt

# Fair assumption I'll want to use anaconda, so let's include that
venv:
	$(CONDA) create -n $(VENV) python=$(PYTHON_VERSION) anaconda -y

jupyter:
	$(PYBIN)/jupyter notebook

haskell: pull-haskell
	docker run -ti --rm -p $(NB_PORT):8888 -v $${PWD}:/home/jovyan/src gibiansky/ihaskell:$(HASKELL_TAG)

pull-haskell:
	docker pull gibiansky/ihaskell:$(HASKELL_TAG)

clean:
	$(CONDA) env remove --name $(VENV)