FROM python:2.7-slim
ARG port

COPY requirements.txt ./
COPY hello.py ./

RUN pip install --no-cache-dir -r requirements.txt

ENV GUNICORN_CMD_ARGS="--bind=0.0.0.0:${port}"
ENTRYPOINT ["gunicorn", "hello:app"]
EXPOSE "${port}"
