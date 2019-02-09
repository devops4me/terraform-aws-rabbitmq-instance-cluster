
### ---> #################### <--- ### || < ####### > || ###
### ---> -------------------- <--- ### || < ------- > || ###
### ---> Service Layer Module <--- ### || < Layer S > || ###
### ---> -------------------- <--- ### || < ------- > || ###
### ---> #################### <--- ### || < ####### > || ###

module rabbitmq-cloud-config
{
    source        = "github.com/devops4me/rabbitmq-fluentd-es-cloud-config"
###########    source        = "github.com/devops4me/rabbitmq-systemd-cloud-config"
    in_node_count = "${ var.in_initial_node_count }"
    in_elasticsearch_url = "elasticsearch-901302010-557078750.eu-west-2.elb.amazonaws.com"
    in_s3_logs_bucket_name = "ecosystem.up.bucket"
    in_s3_bucket_region = "eu-central-1"
}



### ---> ##################### <--- ### || < ####### > || ###
### ---> --------------------- <--- ### || < ------- > || ###
### ---> Instance Layer Module <--- ### || < Layer I > || ###
### ---> --------------------- <--- ### || < ------- > || ###
### ---> ##################### <--- ### || < ####### > || ###

module ec2-instance-cluster
{
    source                = "github.com/devops4me/terraform-aws-ec2-instance-cluster"

    in_node_count         = "${ var.in_initial_node_count }"
    in_subnet_ids         = "${ module.vpc-network.out_public_subnet_ids }"
    in_security_group_ids = [ "${ module.security-group.out_security_group_id }" ]
    in_ami_id             = "${ module.coreos-ami-id.out_ami_id }"
    in_user_data          = "${ module.rabbitmq-cloud-config.out_ignition_config }"
    in_ssh_public_key     = "${ var.in_ssh_public_key }"

    in_route_dependency   = "${ module.vpc-network.out_outgoing_routes }"

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}



### ---> ##################### <--- ### || < ####### > || ###
### ---> --------------------- <--- ### || < ------- > || ###
### ---> Network Layer Modules <--- ### || < Layer N > || ###
### ---> --------------------- <--- ### || < ------- > || ###
### ---> ##################### <--- ### || < ####### > || ###

/*
 | --
 | -- This module creates a VPC and then allocates subnets in a round robin manner
 | -- to each availability zone. For example if 8 subnets are required in a region
 | -- that has 3 availability zones - 2 zones will hold 3 subnets and the 3rd two.
 | --
 | -- Whenever and wherever public subnets are specified, this module knows to create
 | -- an internet gateway and a route out to the net.
 | --
*/
module vpc-network
{
    source                 = "github.com/devops4me/terraform-aws-vpc-network"
    in_vpc_cidr            = "10.66.0.0/16"
    in_num_public_subnets  = 6
    in_num_private_subnets = 0

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}


/*
 | --
 | -- For human beings this application load balancer maps http
 | -- requests to RabbitMQ's management interface on port 15672.
 | --
 | --   http://<http-load-balancer-dns-name>/#/
 | --
 | -- The url brings up the RabbitMQ login page which responds
 | -- to the username "devops4me" and the passowrd that terraform
 | -- provides via the "out_rmq_password" output variable.
 | --
 | -- This load balancer terminates SSL (in the production branch)
 | -- with a provided SSL certificate ID from the AWS Cert Manager.
 | --
 | -- This layer 7 load balancer is slower than its layer 4 cousin
 | -- which is fine as it only services human sys admins.
 | --
module http-load-balancer
{
    source                = "github.com/devops4me/terraform-aws-load-balancer"
    in_vpc_id             = "${ module.vpc-network.out_vpc_id }"
    in_subnet_ids         = "${ module.vpc-network.out_public_subnet_ids }"
    in_security_group_ids = [ "${ module.security-group.out_security_group_id }" ]
    in_ip_addresses       = "${ module.ec2-instance-cluster.out_private_ip_addresses }"
    in_ip_address_count   = "${ var.in_initial_node_count }"
    in_lb_class           = "application"
    in_is_internal        = false

    in_front_end          = [ "http" ]
    in_back_end           = [ "rabbitmq" ]

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}
*/


/*
 | --
 | -- For machines this (layer 4) network load balancer farms
 | -- out TCP traffic using the AMQP protocol on port 5672.
 | --
 | --   amqp://<username>:<password>@<lb-dns-name>:5672/%2F
 | --
 | -- The default username is "devops4me" and the password via
 | -- "out_rmq_password" is auto provisioned by terraform.
 | --
 | -- This high performance load balancer does not open packets
 | -- so refuses to accept security groups in its configuration.
 | --
module amqp-load-balancer
{
    source                = "github.com/devops4me/terraform-aws-load-balancer"
    in_vpc_id             = "${ module.vpc-network.out_vpc_id }"
    in_subnet_ids         = "${ module.vpc-network.out_public_subnet_ids }"
    in_security_group_ids = []
    in_ip_addresses       = "${ module.ec2-instance-cluster.out_private_ip_addresses }"
    in_ip_address_count   = "${ var.in_initial_node_count }"
    in_lb_class           = "network"
    in_is_internal        = false

    in_front_end          = [ "amqp" ]
    in_back_end           = [ "amqp" ]

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}
*/


/*
 | --
 | -- I have used network flow logs in conjunction with the RabbitMQ
 | -- bench test tool (perf-test) to pinpoint the exact set of security
 | -- group rules that are neither overly permissive nor restrictive.
 | --
 | --    https://www.rabbitmq.com/clustering.html
 | --
 | -- The above URL makes the case for the ports required for RabbitMQ
 | -- to cluster correctly.
 | --
*/
module security-group
{
    source         = "github.com/devops4me/terraform-aws-security-group"
    in_ingress     = [ "ssh", "https", "rmq-admin", "rmq-tls", "amqp", "amqp-tls", "http", "etcd-client", "etcd-server", "epmd", "rmq-comms" ]
    in_vpc_id      = "${ module.vpc-network.out_vpc_id }"

    in_ecosystem_name     = "${ var.in_ecosystem_name }"
    in_tag_timestamp      = "${ module.resource-tags.out_tag_timestamp }"
    in_tag_description    = "${ module.resource-tags.out_tag_description }"
}


/*
 | --
 | -- Remember the AWS resource tags! Using this module, every
 | -- infrastructure component is tagged to tell you 5 things.
 | --
 | --   a) who (which IAM user) created the component
 | --   b) which eco-system instance is this component a part of
 | --   c) when (timestamp) was this component created
 | --   d) where (in which AWS region) was this component created
 | --   e) which eco-system class is this component a part of
 | --
*/
module resource-tags
{
    source = "github.com/devops4me/terraform-aws-resource-tags"
}


/*
 | --
 | -- This module dynamically acquires the HVM CoreOS AMI ID for the region that
 | -- this infrastructure is built in (specified by the AWS credentials in play).
 | --
*/
module coreos-ami-id
{
    source = "github.com/devops4me/terraform-aws-coreos-ami-id"
}
