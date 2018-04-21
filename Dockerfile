FROM python:2.7-slim

COPY . .

RUN scripts/install.sh prod

ENTRYPOINT ["scripts/docker_entrypoint.sh"]
EXPOSE "80"
