---
layout: post
title:  AWS public/private network architecture
date:   2023-03-19 22:50:00 -0400
image:  /assets/img/covers/aws-networking.preview.png
category: blog
cover:
  image: /assets/img/covers/aws-networking.svg
tags:
- aws
- cloud
- networking
- terraform
---
So you've got your shiny new AWS account and now you want to start launching
some resources. Your account comes with a default VPC so you can just launch
your resources in there and you're good to go right? *Right‽*

If you've ever started poking around with a brand new account, then you know
it's not that easy. You may eventually throw an Elastic IP on an EC2 instance so
now you can connect to it and it can connect to the Internet. Now, of course,
you've just opened up your network.

## Introducing public/private network architecture

You can separate systems that shouldn't be available from the public Internet
from systems that can access it by using both public and private subnets. Your
private systems can still access the Internet if needed.

![Diagram showing an AWS public/private network architecture][diagram]

Some benefits of this architecture are:

- Public subnets allow resources to be directly accessible from the Internet
- Private subnets preventing resources from being directly accessible from the
  Internet
- A NAT Gateway can allow resources in a private subnet to connect to the
  Internet or other AWS services
- Additional subnet types can be added for additional security or connectivity

## Great! How do I do it?

You can set up a simple public/private network architecture on AWS with a VPC
that has enough IP addresses to split across two or more availability zones (I
recommend three!). Create two subnets in each availability zone, one each for
public and private resources. When determining your CIDR ranges, consider what
resources you need to be available directly from the Internet; this will
determine the size of your public subnet. Your public subnet will likely be much
smaller than your private one in terms of address space.

{% aside {"type":"note", "icon":"<i class=\"fa-solid fa-sticky-note\"></i>"} %}
You don't need to use the entirety of your address space. You can create
subnets that are sufficient for your expected needs are reserve the rest for
future use.
{% endaside %}

### Public subnets

Public subnets will need an Internet Gateway to establish Internet connectivity.
You can use the main route table for all subnets, or a separate route table can
be created for each. The routing table should contain the following two routes
at a minimum:

| Destination | Target                       |
|-------------|------------------------------|
| 0.0.0.0/0   | Internet Gateway for the VPC |
| VPC CIDR    | local                        |

If you're using the default routing table, it should be configured like this
already.

### Private subnets

If your private resources don't need to access the Internet, then they can share
a single route table with the following configuration:

| Destination | Target                       |
|-------------|------------------------------|
| VPC CIDR    | local                        |

If your private resources do need access to the Internet, you'll need to add one
or more NAT Gateways in the public subnets. While each of your subnets can use a
single gateway, and therefore route table, this can lead to a single point of
failure.

A single NAT gateway may be fine for a non-production environment, but for high
availability you should have one per availability zone. This ensures that if an
availability zone goes down, your resources in the over availability zone(s)
will still operate. Multiple gateways will require one route table for each
private subnet.

{% aside {"type":"note", "icon":"<i class=\"fa-solid fa-sticky-note\"></i>"} %}
If your NAT Gateway is in a different availability zone than your
resources, you will be charged higher data transfer fees.
{% endaside %}

Regardless of the number of route tables you end up with, they will each need
the following routes:

| Destination | Target      |
|-------------|-------------|
| 0.0.0.0/0   | NAT Gateway |
| VPC CIDR    | local       |

Make sure to associate each route table with the appropriate subnet(s).

{% aside {"type":"note", "icon":"<i class=\"fa-solid fa-sticky-note\"></i>"} %}
NAT Gateways use an EIP (Elastic IP address), essentially a static public
IP address. You can use this to allow traffic from your resources to connect to
resources you manage elsewhere.
{% endaside %}

## VPC Endpoints

When you try to connect to systems outside your VPC from the private subnet,
your traffic will flow through the NAT Gateway. This includes connecting to AWS
services such as S3 or SSM (Systems Manager). Connecting to these services and
sending your data over the Internet introduces security risks. These risks can
be avoided with [VPC Endpoints][endpoints].

VPC Endpoints allow resources in your VPC to access services over
[PriavteLink][privatelink]. When you create an endpoint for an AWS service, DNS
requests will resolve to the private IP addresses. Therefore, there's no need to
configure any routes to use the VPC endpoint.

If you plan on using SSM to manage your instances, you wil need to configure VPC
endpoints. At a minimum, you will need an endpoint for
**com.amazonaws.region.ssm**. For some features, like Session Manager, you will
also need endpoints for **com.amazonaws.region.ec2messages** and
**com.amazonaws.region.ssmmessages**.

## Putting it into code

There are many infrastructure as code (IaC) options that can support
implementing this architecture, including Amazon's own
[CloudFormation][cloudformation] and [Cloud Development Kit][cdk] (CDK). Here,
we'll be using [Terraform][terraform], a popular open source IaC tool.

We could create each resource individually using the [AWS provider][provider].
However, Amazon has published a number of [modules][modules] to help create
common sets of resources. This includes vpc anc vpc_endpoints. We can use these
in our `main.tf` to setup everything we need.

{% aside {"type":"caution", "icon":"<i class=\"fa-solid fa-circle-exclamation\"></i>"} %}
This is a relatively simple example and doesn't configure a backend for
state storage. It should therefore not be considered production ready.
{% endaside %}

```terraform
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  azs     = ["us-east-1a", "us-east-1b", "us-east-1c"]

  name = "test-vpc"
  cidr = "10.0.0.0/16"

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service = "s3"
      tags    = {
        Name = "s3-vpc-endpoint"
      }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
  }
}
```

From here, you could run `terraform plan` to see all the resources that would be
created, and `terraform apply` to create them.

## Just the beginning

This is really just the beginning to the options available for network
architecture in the cloud. You could have additional subnets that have specific
designations, such as for databases or connecting to an on-prem hosted system.
If you're just getting started with networking in the cloud, though, this should
be a good starting point.

[cdk]: https://aws.amazon.com/cdk/
[cloudformation]: https://aws.amazon.com/cloudformation/
[diagram]: /assets/img/aws-networking/aws-public-private-networking-diagram.svg
[endpoints]: https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html
[modules]: https://registry.terraform.io/browse/modules?provider=aws
[privatelink]: https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-access-aws-services.html
[provider]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
[terraform]: https://www.terraform.io/
