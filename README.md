# Create Greenplum singlenode Docker images
Create the latest Greenplum singlenode docker image by updating `release.sh` and pushing code to the repository. 
`release.sh` contains links to the necessary binaries to build the image. 

CircleCi builds and uploads the image to Docker Hub:  
[Greenplum Images](https://hub.docker.com/r/apadhye/gpdb-singlenode/tags)

Use the below command with the appropriate tag to run the Greenplum container
```bash
docker run --rm -p 5432:5432 --name gpdb54 -itd apadhye/gpdb-singlenode:5.4.1-ds
``` 