all: build

build: build-base-centos build-base-hadoop build-zookeeper \
build-postgres build-namenode build-datanode build-hive build-impala

build-base-centos:
	cd base-centos; \
        docker-compose build base-centos; \
        cd ../;

build-base-hadoop:
	cd base-hadoop; \
        docker-compose build base-hadoop; \
        cd ../;

build-zookeeper:
	docker-compose build zookeeper;

build-postgres:
	docker-compose build postgres;

build-namenode:
	docker-compose build namenode;
	
build-datanode:
	docker-compose build datanode-1; \
	docker-compose build datanode-2; \
	docker-compose build datanode-3;

build-hive:
	docker-compose build hive;

build-impala:
	docker-compose build impala;
