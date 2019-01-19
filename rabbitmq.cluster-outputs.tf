
### ############################################ ###
### [ outputs ] rabbitmq services cluster module ###
### ############################################ ###


output out_rmq_username { value = "${ module.rabbitmq-cloud-config.out_rmq_username }" }
output out_rmq_password { value = "${ module.rabbitmq-cloud-config.out_rmq_password }" }
output out_rmq_http_dns { value = "${ module.http-load-balancer.out_dns_name }"           }
output out_rmq_amqp_dns { value = "${ module.amqp-load-balancer.out_dns_name }"           }
output out_rmq_http_url { value = "http://${ module.http-load-balancer.out_dns_name }/#/" }

/*
 | --
 | -- Queue producers and consumers and the powerful JAVA based
 | -- performance test (perftest) software require the AMQP url
 | -- which talks (by default) over port 5672.
 | --
 | --   amqp://<username>:<password>@<lb-dns-name>:5672/%2F
 | --
 | -- The final backslash in the http url is important and the
 | -- same goes for the url-encoded final backslash here.
 | --
*/
output out_rmq_amqp_url
{
    value = "amqp://${ module.rabbitmq-cloud-config.out_rmq_username }:${ module.rabbitmq-cloud-config.out_rmq_password }@${ module.amqp-load-balancer.out_dns_name }:5672/%2F"
}
