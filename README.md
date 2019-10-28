<p align="center">
  <img src="https://repository-images.githubusercontent.com/214713418/b5503a80-f973-11e9-9057-4b1351e09242" width=350/>
</p>

# Sadcloud

Spin up intentionally insecure AWS infrastructure with Terraform. Initial set of findings are mapped to [ScoutSuite](https://www.github.com/nccgroup/scoutsuite), NCCGroup's Multi-cloud auditing tool. `sadcloud` was created to easily allow security researchers to misconfigure AWS for training purposes, or to use to asses AWS security tools - including built-ins and third-party.

# Security Note - must read

This tool spins up _intentionally vulnerable_ AWS configured resources. **Please do not run it in your production cloud, or anywhere that is meant to be secure.** Consider standing up a new AWS account in which to run this tool. As this tool spins up cloud resources, it will result in charges to your AWS account. Efforts have been made to minimize the costs incurred, but NCC Group and this tool's maintainers are not responsible for any charges or security issues that may result from usage of this tool. Make sure to tear down all - Terraform resources when not using them!

## Setup

Required software: [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

Ensure that your SSH keys are written to `data/ssh_keys/terraform_rsa{,.pub}`.

```
ssh-keygen -t rsa -b 4096 -f data/ssh_keys/terraform_rsa
```

1. `git clone https://github.com/nccgroup/sadcloud.git`
2. `cd sadcloud/sadcloud`

## Environment Setup

Set up the AWS provider (see the "Using Providers Instead of Environment Variables" section below for instructions on avoiding this step):

```
export AWS_ACCESS_KEY_ID="accesskey"
export AWS_SECRET_ACCESS_KEY="secretkey"
export AWS_DEFAULT_REGION="us-east-1"
```

Get Terraform ready:

```
terraform init
```

## Configure sadcloud

Configure sadcloud with your desired misconfigurations:  

* To enable all findings (... excluding those that are in conflict with other findings):
  1. Uncomment all modules in `sadcloud/main.tf`
  2. Either edit the `all_findings` flag in `sadcloud/terraform.tfvars` to `true`, or call `terraform apply` with the flag `--var="all_findings=true"`
  **NOTE: There is currently a limitation where sadcloud creates a VPC per service that needs one. By default, [AWS only allow 5 VPCs per region per account](https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html). To run sadcloud with all_findings, you'll need to [request an increased limit](https://console.aws.amazon.com/support/home#/case/create?issueType=service-limit-increase&limitType=vpc). We have a refactor roadmapped to have all services share a VPC**

* To enable all findings in one or more services:
  1. Uncomment the relevant service(s) in `sadcloud/main.tf`
  2. For a single service, either edit the relevant `all_{service}_findings` flag in `sadcloud/terraform.tfvars` to `true`, or call `terraform apply` with the flag `--var="all_{service}_findings=true"`
  3. For multiple services, either edit the `all_findings` flag in `sadcloud/terraform.tfvars` to `true`, or call `terraform apply` with the flag `--var="all_findings=true"`
  **NOTE: There is currently a [Terraform bug with the Cloudformation service](https://github.com/terraform-providers/terraform-provider-aws/issues/545). To generate Cloudformation findings, you will need to run Terraform apply twice**

* To enable specific findings granularly:
  1. Uncomment the relevant service in `sadcloud/main.tf`
  2. Edit the variables of interest directly in `sadcloud/main.tf`, flipping them to `true` where desired.

**Note:** All misconfigurations in sadcloud are disabled by default. All services are disabled by default to prevent spinning up unnecessary resources. Setting the variable for a misconfiguration to `true` always results in misconfiguration. Running `all_findings` can take 10-15 minutes.

Check it:

```
terraform plan
```

Deploy it:

```
terraform apply
```

Tear it down:

```
terraform destroy
```

**Note:** `terraform apply` will spin up services in AWS. These cost money. Don't forget to `terraform destroy` after you're done. Make sure you `terraform plan` before running `all_findings` so you understand what you're getting yourself into!

## Extras

### Using Providers Instead of Environment Variables

It's possible to set up an AWS provider so you won't have to set environment variables each time.

Create a file called `sadcloud/providers.tf` with the following contents:

```
provider "aws" {
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
  region     = "us-east-1"
}
```
