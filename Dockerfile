FROM python:2.7-slim
ARG port

COPY . .

RUN scripts/install.sh prod
RUN source venv/bin/activate

ENV GUNICORN_CMD_ARGS="--bind=0.0.0.0:${port}"
ENTRYPOINT ["gunicorn", "hello_app.hello:app"]
EXPOSE "${port}"
