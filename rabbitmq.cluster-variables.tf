
/*
 | --
 | -- Six cluster nodes are a good fit for regions with 3 availability zones
 | -- as failures in two zones will robustly see 2 nodes servicing the queue's
 | -- producers and consumers.
 | --
 | -- Even with the auto-scaling solution you should look to maintain a minimum
 | -- of 6 nodes and upscale in multiples of 3 capped at 60 nodes.
 | --
 | -- If you have an eye on costs then consider downgrading the instance type
 | -- rather than the number of instances.
 | --
*/
variable in_initial_node_count
{
    description = "The number of nodes that this cluster will be brought up with."
    default = 6
}


/*
 | --
 | -- You can override this variable and pass in a more appropriate
 | -- name for the eco-system (or subsystem) being engineered.
 | --
*/
variable in_ecosystem_name
{
    description = "The name of this ecosystem which by default is rabbitmq-cluster."
    default = "rabbitmq-cluster"
}


/*
 | --
 | -- This variable can be passed in via the command line or preferably
 | -- using an environment variable like this.
 | --
 | --    export TF_VAR_ssh_public_key='<<public-key-goes-here>>'
 | --
*/
variable ssh_public_key
{
    description = "The ssh public key usable with the development branch of this module."
}
