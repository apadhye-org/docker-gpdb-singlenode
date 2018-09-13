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
export GCLOUD_SERVICE_KEY=$(cat /Users/apadhye/Pivotal/keys/pde-apadhye-gpdb-docker-circleci.json)
circleci local execute -e PIVNET_AUTH_TOKEN=$PIVNET_AUTH_TOKEN \
-e GCLOUD_SERVICE_KEY=$GCLOUD_SERVICE_KEY \
-e GOOGLE_APPLICATION_CREDENTIALS=${HOME}/gcloud-service-key.json \
-e GOOGLE_PROJECT_ID=pde-apadhye \
-e GOOGLE_COMPUTE_ZONE=us-west2-a \
-e GCR_ENDPOINT=gcr.io
```


### Deploy to CircleCI cloud
Adding Secrets to Circle CI (As env variables):
Use the Environment Variables page of the Build > Project > Settings in the CircleCI application.



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


ToDo:
Tag image with appropriate gpdb version
Public access to built images
Deploy to CircleCI cloud
Build bare-bones gpdb image
Build gpdb image with madlib/postgis/ etc.
Show a way to pull and build your own image local using - circle ci local
Restricted access to gcloud service account.





### References:
[Build a Docker Image on CircleCI](https://circleci.com/blog/how-to-build-a-docker-image-on-circleci-2-0/)  
[Local Circle CI](https://circleci.com/docs/2.0/local-cli/])  
[Env Variables for Secrets](https://circleci.com/docs/2.0/env-vars/) 
[gcr.io authentication](https://cloud.google.com/container-registry/docs/advanced-authentication)
[Authenticating gcr with Circle](https://circleci.com/docs/2.0/google-auth/)
[Granting service account access to container registry]https://cloud.google.com/container-registry/docs/access-control#granting_users_and_other_projects_access_to_a_registry
https://console.cloud.google.com/storage/browser?authuser=2&folder=true&organizationId=true&project=pde-apadhye