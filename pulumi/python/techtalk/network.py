from pulumi_aws import ec2

TAGS = {
    'Environment': 'Engineering',
    'Owner': 'Devops',
}

SUBNETS = {
    'us-east-1a': '10.0.0.0/20',
    'us-east-1b': '10.0.16.0/20',
    'us-east-1c': '10.0.32.0/20',
}


def subnet(vpc, zone, cidr):
    '''
    Make and return a subnet from a zone and a cidr.
    '''
    tags = {
        'Name': f'eks-worker-node-subnet-{zone}',
        'kubernetes.io/role/internal-elb': '1',
        'kubernetes.io/cluster/engineering': 'shared',
        **TAGS,
    }
    return ec2.Subnet(
        f'worker_node_subnet_{zone}',
        availability_zone=zone,
        cidr_block=cidr,
        vpc_id=vpc.id,
        map_public_ip_on_launch=False,
        tags=tags,
    )


def make():
    '''
    Make the network infrastructure.
    '''
    # Make vpc.
    tags = {
        'Name': 'engineering',
        'kubernetes.io/cluster/engineering': 'shared',
        **TAGS,
    }
    vpc = ec2.Vpc(
        'main',
        cidr_block='10.0.0.0/16',
        enable_dns_support=True,
        enable_dns_hostnames=True,
        tags=tags,
    )

    # Make egress IP.
    tags = {'Name': 'Worker Node Egress IP', **TAGS}
    eip = ec2.Eip('nat_gateway', vpc=True, tags=tags)

    # Make internet gateway.
    tags = {'Name': 'Internet gateway', **TAGS}
    ec2.InternetGateway('main', vpc_id=vpc.id, tags=tags)

    # Make subnets.
    targets = SUBNETS.items()
    subnets = {zone: subnet(vpc, zone, cidr) for zone, cidr in targets}

    # Make a nat gateway for worker nodes.
    tags = {'Name': 'Worker Node Nat Gateway', **TAGS}
    ec2.NatGateway(
        'worker_node_nat_gateway',
        allocation_id=eip.allocation_id,
        subnet_id=subnets['us-east-1a'].id,
        tags=tags,
    )
