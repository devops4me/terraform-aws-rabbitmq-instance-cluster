
#### This module creates a fixed size (ec2) RabbitMQ 3.7 cluster with etcd peer discovery by bringing together highly reusable blocks. The 4 Layer Cluster Pattern (4LCP) is the architectural underpinning that is brought to life here.

---


```bash
export TF_VAR_ssh_public_key='<<public-key-goes-here>>'
```

## RabbitMQ Performance Bench Tests

amqp://<username>:<password>@<host-url>/vhost
amqp://devops4me:seqapII9F6nxkCt8w3s5@lb-rabbitmq-cluster-81214-1706-o-1090438979.eu-west-2.elb.amazonaws.com/vhost

export RABBITMQ_URI='amqp://devops4me:XFPpkhtuGYQF4uTSOjcj@lb-rabbitmq-cluster-81214-1917-o-2bea3dcce9099e51.elb.eu-west-2.amazonaws.com:5672/%2F'
printenv | grep RABBIT

:5672/%2F




apollo@thinkpad:~/mirror.foreign/rabbitmq-perf-test-2.4.0$ export RABBITMQ_URI='amqp://devops4me:XFPpkhtuGYQF4uTSOjcj@lb-rabbitmq-cluster-81214-1917-o-2bea3dcce9099e51.elb.eu-west-2.amazonaws.com:5672/%2F'
apollo@thinkpad:~/mirror.foreign/rabbitmq-perf-test-2.4.0$ printenv | grep RABBIT
RABBITMQ_URI=amqp://devops4me:XFPpkhtuGYQF4uTSOjcj@lb-rabbitmq-cluster-81214-1917-o-2bea3dcce9099e51.elb.eu-west-2.amazonaws.com:5672/%2F
apollo@thinkpad:~/mirror.foreign/rabbitmq-perf-test-2.4.0$ ./bin/runjava com.rabbitmq.perf.PerfTest --uri $RABBITMQ_URI --consumers 10 --producers 5 --autoack
id: test-193521-771, starting consumer #0
id: test-193521-771, starting consumer #0, channel #0
id: test-193521-771, starting consumer #1
id: test-193521-771, starting consumer #1, channel #0
id: test-193521-771, starting consumer #2
id: test-193521-771, starting consumer #2, channel #0
id: test-193521-771, starting consumer #3
id: test-193521-771, starting consumer #3, channel #0
id: test-193521-771, starting consumer #4
id: test-193521-771, starting consumer #4, channel #0
id: test-193521-771, starting consumer #5
id: test-193521-771, starting consumer #5, channel #0
id: test-193521-771, starting consumer #6
id: test-193521-771, starting consumer #6, channel #0
id: test-193521-771, starting consumer #7
id: test-193521-771, starting consumer #7, channel #0
id: test-193521-771, starting consumer #8
id: test-193521-771, starting consumer #8, channel #0
id: test-193521-771, starting consumer #9
id: test-193521-771, starting consumer #9, channel #0
id: test-193521-771, starting producer #0
id: test-193521-771, starting producer #0, channel #0
id: test-193521-771, starting producer #1
id: test-193521-771, starting producer #1, channel #0
id: test-193521-771, starting producer #2
id: test-193521-771, starting producer #2, channel #0
id: test-193521-771, starting producer #3
id: test-193521-771, starting producer #3, channel #0
id: test-193521-771, starting producer #4
id: test-193521-771, starting producer #4, channel #0
id: test-193521-771, time: 1.223s, sent: 0.82 msg/s, received: 0 msg/s, min/median/75th/95th/99th consumer latency: 0/0/0/0/0 µs
id: test-193521-771, time: 2.223s, sent: 55341 msg/s, received: 128229 msg/s, min/median/75th/95th/99th consumer latency: 9494/125465/248148/357311/400685 µs
id: test-193521-771, time: 3.223s, sent: 32921 msg/s, received: 154400 msg/s, min/median/75th/95th/99th consumer latency: 372988/823526/1055857/1245413/1349195 µs
id: test-193521-771, time: 4.223s, sent: 35303 msg/s, received: 166121 msg/s, min/median/75th/95th/99th consumer latency: 1250749/1685109/1865089/2101237/2206980 µs
id: test-193521-771, time: 5.223s, sent: 25463 msg/s, received: 157205 msg/s, min/median/75th/95th/99th consumer latency: 1748294/2368511/2543894/2862142/3052903 µs
id: test-193521-771, time: 6.223s, sent: 95591 msg/s, received: 146214 msg/s, min/median/75th/95th/99th consumer latency: 2502852/3089379/3350689/3816293/3942892 µs
id: test-193521-771, time: 7.223s, sent: 19735 msg/s, received: 161981 msg/s, min/median/75th/95th/99th consumer latency: 3013665/3599252/4021046/4539494/4759868 µs
id: test-193521-771, time: 8.223s, sent: 19769 msg/s, received: 158545 msg/s, min/median/75th/95th/99th consumer latency: 3481962/4130046/4436326/4778014/4843295 µs
id: test-193521-771, time: 9.223s, sent: 53438 msg/s, received: 150854 msg/s, min/median/75th/95th/99th consumer latency: 4011810/4505409/5108205/5629346/5742271 µs
id: test-193521-771, time: 10.223s, sent: 86297 msg/s, received: 161250 msg/s, min/median/75th/95th/99th consumer latency: 4361251/4951661/5763969/6295674/6601910 µs
id: test-193521-771, time: 11.223s, sent: 21289 msg/s, received: 149021 msg/s, min/median/75th/95th/99th consumer latency: 4575946/5398810/6267130/6684997/6946443 µs












```bash
## ----------=------ ##
## Install Terraform ##
## ----------=------ ##

## ----------=---------- ##
## Setup AWS Credentials ##
## ----------=---------- ##


## -----------------------=------ ##
## Download and install perf test ##
## ------------------------------ ##
wget https://bintray.com/rabbitmq/java-tools/download_file?file_path=perf-test%2F2.4.0%2Frabbitmq-perf-test-2.4.0-bin.tar.gz
unzip ...
cd rabbitmq-perf-test-2.4.0
export RABBITMQ_URI=amqp://<username>:<password>@<host-url>/vhost
printenv # to check the RABBITMQ_URI environment variable

## -------------------------------- ##
## Now we install java if necessary ##
## -------------------------------- ##
java -version
sudo apt-get update
sudo apt --assume-yes install default-jre
java -version
sudo update-alternatives --config java
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
echo $JAVA_HOME

## --------------------------------- ##
## Run the RabbitMQ performance test ##
## --------------------------------- ##
./bin/runjava com.rabbitmq.perf.PerfTest --uri $RABBITMQ_URI --consumers 10 --producers 5 --autoack
```

To get the perftest (pre-docker environment) going you

- install JAVA - replace JAVA_HOME using **`update-alternatives`**
- export the AWS credentials (or put them in the usual places)
- use terraform apply to create the rabbitmq cluster
- note that **`devops4me`** is the **default username**
- grab load balancer dns name from **`out_load_balancer_dns_name`**
- grab the rabbitmq user password from **`out_rmq_password`**
- **allow traffic** with security group rules through **ports xx, yy, zz**
- configure the load balancer's **front** and **back-end**
- **download the perf-test tar archive** and extract into folder
- enter the folder
- export uri using **`export RABBITMQ_URI=amqp://<username>:<password>@<host-url>/vhost`**


## Troubleshoot | Connection Refused

If **`Connection refused`** relax the **AWS security group** and/or configure amqp traffic to flow through the load-balancer's front end (listener). This has already been done it the **devops4me RabbitMQ Terraform Cluster Module**.

```
Main thread caught exception: java.net.ConnectException: Connection refused (Connection refused)
16:02:25.092 [main] ERROR com.rabbitmq.perf.PerfTest - Main thread caught exception
java.net.ConnectException: Connection refused (Connection refused)
```
