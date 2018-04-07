FROM python:2.7-slim
ARG port

COPY requirements.txt ./
COPY ./hello_app ./hello_app

RUN pip install --no-cache-dir -r requirements.txt

ENV GUNICORN_CMD_ARGS="--bind=0.0.0.0:${port}"
ENTRYPOINT ["gunicorn", "hello_app.hello:app"]
EXPOSE "${port}"
