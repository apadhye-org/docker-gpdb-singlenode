# Using CircleCI
### CircleCI configuration file
Create .circleci/config.yml

### Testing CircleCI locally
Install Local CircleCI:
```bash
curl https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh \
	--fail --show-error | bash
```

Validate config file and execute locally:
```bash
circleci config validate
export PIVNET_AUTH_TOKEN=$(cat /Users/apadhye/Pivotal/keys/pivnet-auth-token)
export DOCKER_HUB_PASSWORD=$(cat /Users/apadhye/Pivotal/keys/docker-hub-password)
circleci local execute -e PIVNET_AUTH_TOKEN=$PIVNET_AUTH_TOKEN \
-e DOCKER_HUB_USERNAME=apadhye \
-e DOCKER_HUB_PASSWORD=${DOCKER_HUB_PASSWORD}
```


### Deploy to CircleCI cloud
Add Secrets to Circle CI (As env variables)  
Use the Environment Variables page of the Build > Project > Settings in the CircleCI application.
Commit to kickoff build



# ToDo:
* Show a way to pull and build your own image local using - circle ci local
* Docs for how to use the images
 vanilla - su - gadmin / psql
 ds - Install madlib/postgis on database.

* Cleaner way to source release information in circleci
* Derive appropriate Gpdb version from GPDB_INSTALLER
* Use just one dockerfile instead of two to build the images - tagging intermediate containers



# Appendix
### Connecting to Google Container registry from CircleCI docker container
* Create service account
* Set content of file as ENV variable
```bash
export GCLOUD_SERVICE_KEY=$(cat /Users/apadhye/Pivotal/keys/pde-apadhye-gpdb-docker-circleci.json)
```
* Add login auth in Dockerfile
* Create test.json with service account credentials
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock docker:18.06.1-ce-git sh
apk add bash wget curl python
curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=~/gcloud --disable-prompts
/root/gcloud/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file=./test.json
/root/gcloud/google-cloud-sdk/bin/gcloud config set project pde-apadhye
/root/gcloud/google-cloud-sdk/bin/gcloud config set compute/zone us-west2-a

docker login -u _json_key --password-stdin https://gcr.io < test.json
# OR (something needs to be fixed in the commands below to use the credential helper)
# /root/gcloud/google-cloud-sdk/bin/gcloud components install docker-credential-gcr -q
# /root/gcloud/google-cloud-sdk/bin/gcloud auth configure-docker -q

docker push gcr.io/pde-apadhye/app

```

### To deploy to gcr.io
Need the following env variables in CircleCI
```bash
export GCLOUD_SERVICE_KEY=$(cat /Users/apadhye/Pivotal/keys/pde-apadhye-gpdb-docker-circleci.json)
circleci local execute -e PIVNET_AUTH_TOKEN=$PIVNET_AUTH_TOKEN \
-e GCLOUD_SERVICE_KEY=$GCLOUD_SERVICE_KEY \
-e GOOGLE_APPLICATION_CREDENTIALS=${HOME}/gcloud-service-key.json \
-e GOOGLE_PROJECT_ID=pde-apadhye \
-e GOOGLE_COMPUTE_ZONE=us-west2-a \
-e GCR_ENDPOINT=gcr.io
```

Commands in yaml to push to gcr.io
```bash
  - run:
      name: Install gcloud
      command:
        curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=~/gcloud --disable-prompts
  - run:
      name: Store Service Account
      command: |
        echo $GCLOUD_SERVICE_KEY > ${HOME}/gcloud-service-key.json
        cat ${HOME}/gcloud-service-key.json
  - deploy:
      name: Push application Docker image
      command: |
        source release.sh
        if [ "${CIRCLE_BRANCH}" == "master" ]; then
          /root/gcloud/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file=${HOME}/gcloud-service-key.json
          /root/gcloud/google-cloud-sdk/bin/gcloud config set project $GOOGLE_PROJECT_ID
          /root/gcloud/google-cloud-sdk/bin/gcloud config set compute/zone $GOOGLE_COMPUTE_ZONE
          docker login -u _json_key --password-stdin https://gcr.io < ${HOME}/gcloud-service-key.json
          docker tag app ${GCR_ENDPOINT}/${GOOGLE_PROJECT_ID}/gpdb-singlenode:${GPDB_VERSION}
          docker push ${GCR_ENDPOINT}/${GOOGLE_PROJECT_ID}/gpdb-singlenode:${GPDB_VERSION}
        fi
```


### Running docker in a container using local daemon:
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock docker:18.06.1-ce-git sh
```

### Using LABEL to store metadata for intermediate images



### References:
[Build a Docker Image on CircleCI](https://circleci.com/blog/how-to-build-a-docker-image-on-circleci-2-0/)  
[Local Circle CI](https://circleci.com/docs/2.0/local-cli/])  
[Env Variables for Secrets](https://circleci.com/docs/2.0/env-vars/) 
[gcr.io authentication](https://cloud.google.com/container-registry/docs/advanced-authentication)
[Authenticating gcr with Circle](https://circleci.com/docs/2.0/google-auth/)
[Granting service account access to container registry](https://cloud.google.com/container-registry/docs/access-control#granting_users_and_other_projects_access_to_a_registry)
https://console.cloud.google.com/storage/browser?authuser=2&folder=true&organizationId=true&project=pde-apadhye
[Labelling intermediate images](https://github.com/moby/moby/issues/5603)