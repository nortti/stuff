FROM python:2.7-slim
ARG port

COPY . .

RUN scripts/install.sh prod

ENTRYPOINT ["scripts/docker_entrypoint.sh", "${port}"]
EXPOSE "${port}"
