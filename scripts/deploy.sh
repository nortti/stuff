#!/usr/bin/env bash
cd ~/stuff
git checkout master \
    && git pull \
    && rm -rf venv \
    && virtualenv -p python2 venv \
    && . venv/bin/activate \
    && pip install -r requirements.txt \
    && gunicorn hello:app &
