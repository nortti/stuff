#!/bin/bash
#
# Deploy the application from travis.

# Exit on error
set -e

port=8200

# Build & push docker image from travis
echo "$DOCKER_PASS" | docker login -u="$DOCKER_USER" --password-stdin
docker build -t "$DOCKER_USER/$DOCKER_IMAGE" \
  -f "$TRAVIS_BUILD_DIR"/docker/Dockerfile \
  --build-arg port="$port" \
  "$TRAVIS_BUILD_DIR"
docker push "$DOCKER_USER/$DOCKER_IMAGE"

# Free travis doesn't feature ssh keys. Workaround is to store them as
# environment variables. Instead of escaping special characters we've
# stored the key in base64-format.
echo "$ID_RSA" | base64 --decode > id_rsa
chmod 600 id_rsa

# Pull and run instance of docker image from prod over ssh
ssh -i id_rsa \
  -o StrictHostKeyChecking=no \
  "$PROD_USER@$PROD_ADDRESS" << EOF
    echo "$DOCKER_PASS" | docker login -u="$DOCKER_USER" --password-stdin
    docker pull "$DOCKER_USER/$DOCKER_IMAGE"
    docker rm -f "$DOCKER_IMAGE"
    docker run -d \
      -p "$port:$port" \
      --name "$DOCKER_IMAGE" \
      "$DOCKER_USER/$DOCKER_IMAGE"
EOF

rm id_rsa
