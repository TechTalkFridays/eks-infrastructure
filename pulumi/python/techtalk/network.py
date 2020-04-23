from pulumi_aws import ec2

TAGS = {
    "Environment": "Engineering",
    "Owner": "Devops",
}

SUBNETS = {
    "us-east-1a": "10.0.0.0/20",
    "us-east-1b": "10.0.16.0/20",
    "us-east-1c": "10.0.32.0/20",
}


def subnet(vpc, zone, cidr):
    """
    Make and return a subnet from a zone and a cidr.
    """
    tags = {
        "Name": f"eks-worker-node-subnet-{zone}",
        "kubernetes.io/role/internal-elb": "1",
        "kubernetes.io/cluster/engineering": "shared",
        **TAGS,
    }
    return ec2.Subnet(
        f"worker_node_subnet_{zone}",
        availability_zone=zone,
        cidr_block=cidr,
        vpc_id=vpc.id,
        map_public_ip_on_launch=False,
        tags=tags,
    )


def association(name, zone, subnet, table):
    """
    Make a routing association.
    """
    ec2.RouteTableAssociation(
        f"{name}_{zone}", subnet_id=subnet.id, route_table_id=table.id,
    )


def make():
    """
    Make the network infrastructure.
    """
    # Make vpc.
    tags = {
        "Name": "engineering",
        "kubernetes.io/cluster/engineering": "shared",
        **TAGS,
    }
    vpc = ec2.Vpc(
        "main",
        cidr_block="10.0.0.0/16",
        enable_dns_support=True,
        enable_dns_hostnames=True,
        tags=tags,
    )

    # Make egress IP.
    tags = {"Name": "Worker Node Egress IP", **TAGS}
    eip = ec2.Eip("nat_gateway", vpc=True, tags=tags)

    # Make internet gateway.
    tags = {"Name": "Internet gateway", **TAGS}
    gateway = ec2.InternetGateway("main", vpc_id=vpc.id, tags=tags)

    # Make subnets.
    targets = SUBNETS.items()
    subnets = {zone: subnet(vpc, zone, cidr) for zone, cidr in targets}

    # Make a nat gateway for worker nodes.
    tags = {"Name": "Worker Node Nat Gateway", **TAGS}
    ec2.NatGateway(
        "worker_node_nat_gateway",
        allocation_id=eip.allocation_id,
        subnet_id=subnets["us-east-1a"].id,
        tags=tags,
    )

    # Make public route.
    tags = {"Name": "Public Rote", **TAGS}
    routes = [{"cidr_block": "0.0.0.0/0", "gateway_id": gateway.id}]
    ec2.RouteTable(
        "public_rote", vpc_id=vpc.id, routes=routes, tags=tags,
    )

    # Make worker route.
    tags = {"Name": "Worker Node Route", **TAGS}
    routes = [{"cidr_block": "0.0.0.0/0", "gateway_id": gateway.id}]
    table = ec2.RouteTable(
        "worker_node_route", vpc_id=vpc.id, routes=routes, tags=tags,
    )

    # Make route associations.
    for zone, subnet in subnets:
        association("worker_node_subnets", zone, subnet, table)
