
#### Create (in 5 minutes) a RabbitMQ ec2 instance cluster in the AWS cloud. This module pools configuration from a [RabbitMQ service layer](https://github.com/devops4me/terraform-ignition-rabbitmq-config), an [ec2 instance layer](https://github.com/devops4me/terraform-aws-ec2-instance-cluster) and highly reusable network layer modules. It employs [RabbitMQ PerfTest](https://rabbitmq.github.io/rabbitmq-perf-test/stable/htmlsingle/) for integration and performance testing.

---

# Create RabbitMQ 3.7 Cluster | In 5 minutes

If you like Docker you can create and test this RabbitMQ cluster from within a Dockerized terraform environment. If your laptop has a Terraform environment then continue here to create the cluster. **Either way let's do this in 5 minutes.**

### Prerequisite

You'll need your [AWS credentials](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html) correctly setup, a Python environment for acquiring the etcd discovery url along with Git and a recent version of Terraform

## Steps | Create the RabbitMQ Cluster

```bash
git clone https://github.com/devops4me/terraform-aws-rabbitmq-instance-cluster rabbitmq.instance.cluster
cd rabbitmq.instance.cluster
terraform init
terraform apply
```

That's it! Your RabbitMQ cluster should now be running in AWS.



## Steps | Login to the RabbitMQ Admin Console

The last thing **`terraform apply`** prints out are

- two load balancer urls
- an AMQP connect uri
- a **username** (which you can customize later) and
- a **randomly generated password**

So to login to the RabbitMQ admin user interface you

- visit the **`out_rmq_http_url`** starting with **`http://`**
- enter the default **`devops4me`** username
- copy and paste the alphanumeric password

You should be presented with a console listing 6 nodes with two (typically) spread over the 3 availability zones of your region.


---


## The 3 Layer Cluster Architecture

**Making devops engineers super-productive by employing super-reusable Terraform modules, is the point behind the 3 layer cluster design pattern.**

The 3 layers and the key technologies that feature within them are

- the **service configuration layer** - either cloud-config yaml or systemd / ignition
- the **instance configuration layer** - either vanilla ec2 or auto-scaling instances
- the **network configuration layer** - vpc (subnets++), load balancers and security groups

### What does each layer know? Who does it tell?

The ec2 instance layer is central. Whoever calls it knows which **instance type** to use, **which AMI to boot from**, the storage size and so on.

### What 2 things does the service layer tell the instance layer?

The layer responsible for configuring services **tells the instance layer** two things.

- **configure yourself with this user-data** (cloud-config yaml or systemd unit ignition configs)
- boot up this **number of instances**

### What the network layer tells the instance layer?

The network layer says to the instance layer

- wake up in this VPC (and subnet) in this availability zone
- use this security group to prohibit certain types of traffic

By virtue of the subnet it lives in, the instance is assured of routes, gateways, DNS, DHCP and address translators so that it can access the internet.

### What the instance layer gives the network layer?

Finally the instance layer gives the network layer a string of IP addresses which are connected to the back-end of a load balancer.


---


## everything is a cluster

In today's DevOps world **everything is a cluster**! Services are backed by clusters, not servers. It's the only way to handle insanely high volumes whilst remaining performant, resilient and highly available.

You **need to cluster** RabbitMQ, Jenkins, nginx, Redis, MongoDB, elasticsearch, all as standard.


---


## module reuse

Reusability is only achievable with a high quality design. High quality modules are well documented. They work in **any region**, with **any Linux AMI**, in **any AWS account** and any business domain.


So how does each of the 3 cluster architecture layers engender reuse?


### reuse the instance layer

The  3 layer cluster facilitates a modular design and allows you to **reuse the same ec2 instance (or auto-scaling) module** whether you are building a RabbitMQ cluster, an nginx cluster or indeed an etcd cluster.


### reuse the network layer

With the serverless paradigm, you don't get to build the ec2 instances yourself.

You still get to **reuse the network layer** because cloud services demand VPC / subnet housing, routes, peering and more.

Thus the network modules in your 3 layer cluster architecture still enjoy reuse when provisioning

- a RDS (eg postgres) database cluster
- an AWS Redis cluster
- an AWS ElasticSearch cluster
- an EKS (Elastic Kubernetes Service) cluster


### reuse the services layer

You only get **one text string** from the service layer which you pump into the user data field of each instance.

The text will either be **cloud-config yaml** or ignition generated json text that is a transpilation of simple systemd unit files.

More often than not the service layer is little more than a **`docker run`** statement to configure the container instance of a docker image. This example shows the service layer configuration of a RabbitMQ cluster.

### RabbitMQ SystemD Unit Configuration

```ini
[Unit]
Description=RabbitMQ Node with ETCD Peer Discovery
After=docker.socket etcd-member.service
Requires=docker.socket etcd-member.service

[Service]
ExecStart=/usr/bin/docker run \
    --detach        \
    --name rabbitmq \
    --network host  \
    --env RABBITMQ_ERLANG_COOKIE="${ erlang_cookie }" \
    --env RABBITMQ_DEFAULT_USER="${ rbmq_username }"  \
    --env RABBITMQ_DEFAULT_PASS="${ rbmq_password }"  \
    devops4me/rabbitmq-3.7

[Install]
WantedBy=multi-user.target
```

The above systemd configuration is then [transpiled by ignition](https://coreos.com/os/docs/latest/provisioning.html) and the machine readable JSON content is pumped in to configure each ec2 instance as it boots up.

Here systemd is instructed to run the **[RabbitMQ 3.7 docker container built with this Dockerfile](https://github.com/devops4me/rabbitmq-3.7/blob/master/Dockerfile)** after installing the etcd key-value store for peer discovery.
