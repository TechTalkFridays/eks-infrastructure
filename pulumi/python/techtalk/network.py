from pulumi_aws import ec2

TAGS = {
    'Environment': 'Engineering',
    'Owner': 'Devops',
}

SUBNETS = {
    'worker': {
        'tags': {
            'kubernetes.io/role/internal-elb': '1',
            'kubernetes.io/cluster/engineering': 'shared',
        },
        'zones': {
            'us-east-1a': '10.0.0.0/20',
            'us-east-1b': '10.0.16.0/20',
            'us-east-1c': '10.0.32.0/20',
        },
    },
    'eks': {
        'tags': {
            'kubernetes.io/role/internal-elb': '1',
            'kubernetes.io/cluster/engineering': 'shared',
        },
        'zones': {
            'us-east-1a': '10.0.0.0/20',
            'us-east-1b': '10.0.16.0/20',
            'us-east-1c': '10.0.32.0/20',
        },
    },
    'alb': {
        'tags': {
            'kubernetes.io/role/elb': '1',
        },
        'zones': {
            'us-east-1a': '10.1.3.0/24',
            'us-east-1b': '10.1.4.0/24',
            'us-east-1c': '10.1.5.0/24',
        },
    }
}


def make_subnet(vpc, name, subnet, zone, cidr):
    '''
    Make a subnet.
    '''
    name = f'{name}-subnet-{zone}'
    tags = {
        'Name': name,
        **subnet['tags'],
        **TAGS,
    }
    return ec2.Subnet(
        name,
        availability_zone=zone,
        cidr_block=cidr,
        vpc_id=vpc.id,
        map_public_ip_on_launch=False,
        tags=tags,
    )


def make_gateways(vpc, eip, subnets):
    '''
    Make all gateways.
    '''
    # Make a nat gateway for worker nodes.
    tags = {'Name': 'worker', **TAGS}
    worker = ec2.NatGateway(
        'worker',
        allocation_id=eip.allocation_id,
        subnet_id=subnets['alb']['us-east-1a'].id,
        tags=tags,
    )

    # Make internet gateway.
    tags = {'Name': 'public', **TAGS}
    public = ec2.InternetGateway('public', vpc_id=vpc.id, tags=tags)

    return {
        'worker': worker,
        'public': public,
    }


def make_association(name, zone, subnet, table):
    '''
    Associate a subnet with a route.
    '''
    return ec2.RouteTableAssociation(
        f'{name}-{zone}', subnet_id=subnet.id, route_table_id=table.id,
    )


def make_route(vpc, name, subnet, gateway):
    '''
    Make a route.
    '''
    # Make the route.
    route_name = f'{name}-{gateway._name}-route'
    tags = {'Name': route_name, **TAGS}
    routes = [{'cidr_block': '0.0.0.0/0', 'gateway_id': gateway.id}]
    table = ec2.RouteTable(
        route_name, vpc_id=vpc.id, routes=routes, tags=tags,
    )

    # Make the associations:
    associations = {
        make_association(route_name, zone, value, table)
        for zone, value in subnet.items()
    }


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

    # Make subnets.
    subnets = {
        name: {
            zone: make_subnet(vpc, name, subnet, zone, cidr)
            for zone, cidr in subnet['zones'].items()
        }
        for name, subnet in SUBNETS.items()
    }

    # Make egress IP.
    tags = {'Name': 'worker-egress-ip', **TAGS}
    eip = ec2.Eip('nat-eip', vpc=True, tags=tags)

    # Make gateways.
    gateways = make_gateways(vpc, eip, subnets)

    # Make routes.
    targets = {
        'worker': ['worker', 'eks', 'alb'],
        'public': [],
    }
    routes = {
        gateway: {
            name: make_route(vpc, name, subnets[name], gateways[gateway])
            for name in targets
        }
        for gateway, targets in targets.items()
    }

    # Return infrastructure.
    return {
        'vpc': vpc,
        'subnets': subnets,
        'eip': eip,
        'gateways': gateways,
        'routes': routes,
    }
