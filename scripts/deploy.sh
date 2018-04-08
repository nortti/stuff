#!/bin/bash
#
# Deploy the application to staging or production from travis.

# Exit on error
set -e

if [ "$TRAVIS_BRANCH" == "master" ]; then
  port=8200
  image=stacks-production
elif [ "$TRAVIS_BRANCH" == "develop" ]; then
  port=8210
  image=stacks-staging
fi

# Build & push docker image from travis
echo "$DOCKER_PASS" | docker login -u="$DOCKER_USER" --password-stdin
docker build -t "$DOCKER_USER/$image" \
  -f "$TRAVIS_BUILD_DIR"/docker/Dockerfile \
  --build-arg port="$port" \
  "$TRAVIS_BUILD_DIR"
docker push "$DOCKER_USER/$image"

# Free travis doesn't feature ssh keys. Workaround is to store them as
# environment variables. Instead of escaping special characters we've
# stored the key in base64-format.
echo "$ID_RSA" | base64 --decode > id_rsa
chmod 600 id_rsa

# Pull and run a docker container over ssh
ssh -i id_rsa \
  -o StrictHostKeyChecking=no \
  "$PROD_USER@$PROD_ADDRESS" << EOF
    echo "$DOCKER_PASS" | docker login -u="$DOCKER_USER" --password-stdin
    docker pull "$DOCKER_USER/$image"
    docker rm -f "$image"
    docker run -d \
      -p "$port:$port" \
      --name "$image" \
      "$DOCKER_USER/$image"
EOF

rm id_rsa
