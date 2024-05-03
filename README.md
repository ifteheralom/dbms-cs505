# CS505-001: Intermediate Tops in Database Systems (Spring 2024)
## Project: Performance benchmarking | Apache Derby 10.13.1.1

### About Apache Derby
Apache Derby is an open-source relational database management system (RDBMS) developed under the auspices of the Apache Software Foundation. It is written in Java, which ensures that it can easily integrate with Java applications and run on any platform that supports a Java Virtual Machine (JVM). Targeted primarily at small and medium-sized applications, Derby provides a lightweight yet robust database solution that can be embedded in Java programs and used in client-server frameworks as well. Its small footprint and straightforward setup make it an ideal choice for developers looking for a database solution that can be easily incorporated directly into their applications without necessitating large-scale database server configurations. Derby is also known for its strong security features and standards compliance, which add to its utility in a variety of development scenarios.

## Prerequisites for installation
- Ubuntu 20.04
- Java (we used OpenJDK 11)
- CMake

## Installation instructions
- We followed the instruction provided by official site: https://db.apache.org/derby/papers/DerbyTut/install_software.html

## Clone the project
``` sh
git clone git@github.com:ifteheralom/dbms-cs505.git
cd derby
```

## Download and prepare TPC-H data
``` sh
git clone https://github.com/electrum/tpch-dbgen.git
cd tpch-dbgen
make
./dbgen -s 1
```
These commands will download TPC-H dataset and generate a number of ``.tbl`` files, whose data will be imported at the end of databse set up and initialization.

## Prepare database
- Start Derby in Server mode
``` sh
In the derby home directory:
./bin/startNetworkServer
```
- Create a database in Derby
``` sh
In another terminal window, connect to derby server and create and database.
connect 'jdbc:derby://localhost:1527/tpch;user=xxx;password=yyy';
```
- Now we need to create the required tables for populating TPC-H data
``` sh
The required table structures are present in the derby/tables directory.
Execute them in derby command line interface connected in last step.
```
- Next, we need to import the TPC-H data (as prepared above) into the database.
--We can wither use command line SQL instructions or a databse browser for this task. In our case we used **SQuirreL SQL client**. It can be accessed in the following location.
``` sh
http://www.squirrelsql.org/index.php?page=translations
```

## Run Tests
- Onec our databse is installed and TPC-H data loaded, we can run the queries from ``derby/queries/``.
- We prepared a bash script for this task. It can be executed from the ``/derby/`` directory of this project.
``` sh
cd derby
./run_test.sh <user> <pass> <query_file_name>
```
- The results of the test will be generated in ``results`` directory. The system stats will also be generated as ``vmstat_output.txt``.

