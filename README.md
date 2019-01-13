# Big Data Docker Containers
Docker containers for running big data platform. Containers for Hadoop NameNode, Hadoop DataNodes, Hive, Impala, Zookeeper and Postgres. 
## Building Containers
All containers are build from docker-compose files, but docker-compose does not support building containers from a base image.  A Makefile has been included to build the containers.
__Build all Containers__
```
make build
```
__Build Individual Container__
```
make build-hive
```
## Running Containers
All containers can be run using docker-compose
The -p option is used to specify the docker network for the containers.
```
docker-compose -p bigdata-net up
```
Individual containers can be run by referencing the container name. This is typically not recommended however as there are dependencies between a number of the containers.
```
docker-compose -p bigdata-net up postgres
```
## Accessing Containers
Use docker-compose to access containers by name.
```
docker-compose -p bigdata-net exec impala bash
```
## Container Structure
<img src="https://raw.githubusercontent.com/mtempleton94/bigdata-docker/master/images/bigdata-docker-structure.PNG" width="650">

## Adding Data to the HDFS
1. Copy files to the NameNode container.
```
docker cp <data-file> <hadoop-container-id>:/
```
2. Enter the NameNode Container
```
docker-compose -p bigdata-net exec namenode bash
```
3. Create a directory in the HDFS for the files
```
hdfs dfs -mkdir -p /user/data/
```
4. Add the files to the HDFS directory
```
hdfs dfs -put <data-file> /user/data/
```
## Running Hive Queries
__Using beeline__
1. From the Hive container, run the beeline CLI
```
beeline
```
2. Connect to HiveServer2
```
!connect jdbc:hive2://localhost:10000
```
3. Run Queries
```
show databases;
```
__Using JDBC with Maven__
1. From the Hive container, navigate to the directory containing the pom.xml file and project file
```
cd jdbc
```
2. Run the Maven package command
```
mvn package
```
3. Run the Java Project
```
cd target/
java -jar hive-jdbc-example-1.0-jar-with-dependencies.jar
```
## Running Impala Queries
__Using Impala Shell__
1. Start the Impala Shell
```
impala-shell -i localhost
```
2. Run Queries
```
show databases;
```
