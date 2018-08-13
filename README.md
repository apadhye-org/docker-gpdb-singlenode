### Set PIVNET_AUTH_TOKEN env variable to download binaries:
```bash
export PIVNET_AUTH_TOKEN=<auth token availabel on network.pivotal.io account>
```

### Download Greenplum binaries from PivNet
The download.sh script downloads the following files from PivNet
* greenplum-db-5.10.2-rhel6-x86_64.zip
* DataSciencePython-1.1.1-gp5-rhel6-x86_64.gppkg
* madlib-1.14-gp5-rhel6-x86_64.tar.gz
* postgis-2.1.5-gp5-rhel6-x86_64.gppkg
```bash
cd docker-gpdb/pivotal
./download.sh
cd ../..
```

###  Create docker-machine
Create a docker machine if one does not already exist:
```bash
docker-machine create --virtualbox-disk-size 10000 gpdb
```

### Point to docker-machine and create gpdb:
```bash
eval "$(docker-machine env gpdb)"

#  Network bridge for communication between gpdb and airflow
docker network create -d bridge gpbridge
```


# Greenplum Docker
### Build and Run GPDB Container
Build docker image passing parameters:
```bash
# Bu
cd docker-gpdb
docker build \
. -t gpdb54:latest
cd ..

# Run GPDB container
docker run --rm --network gpbridge -p 5432:5432 --name gpdb54 -itd gpdb54:latest
```


### Setup GPDB
(Password: pivotal)

```bash
# Create database and user
psql -h $(docker-machine ip gpdb) -U gpadmin -d gpadmin -c 'create database test'
psql -h $(docker-machine ip gpdb) -U gpadmin -d gpadmin -c "create user test with superuser password 'test'"

# Initialize madlib and plpython
docker exec -it gpdb54 su gpadmin -l -c "/usr/local/greenplum-db/madlib/bin/madpack -s madlib -p greenplum -c gpadmin@localhost:5432/${DATABASE} install"
docker exec -it gpdb54 su gpadmin -l -c "/usr/local/greenplum-db/share/postgresql/contrib/postgis-2.1/postgis_manager.sh ${DATABASE} install"
docker exec -it gpdb54 su gpadmin -l -c "createlang plpythonu -d ${DATABASE}"
```