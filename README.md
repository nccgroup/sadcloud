<p align="center">
  <img src="https://repository-images.githubusercontent.com/214713418/b5503a80-f973-11e9-9057-4b1351e09242" width=350/>
</p>

# Sadcloud

`sadcloud` is a tool for spinning up insecure AWS infrastructure with Terraform.

It supports approx. **84** misconfigurations across **22** AWS Services.
The inital set of misconfigurations were drawn from [ScoutSuite](https://www.github.com/nccgroup/scoutsuite), NCCGroup's Multi-cloud auditing tool.

`sadcloud` was created to easily allow security researchers to misconfigure AWS for training purposes, or to use to asses AWS security tools - including built-ins and third-party.

# Security Note - must read

This tool spins up _intentionally vulnerable_ AWS configured resources. **Please do not run it in your production cloud, or anywhere that is meant to be secure.** Consider standing up a new AWS account in which to run this tool. As this tool spins up cloud resources, it will result in charges to your AWS account. Efforts have been made to minimize the costs incurred, but NCC Group and this tool's maintainers are not responsible for any charges or security issues that may result from usage of this tool. Make sure to tear down all - Terraform resources when not using them!

### Costs

A 24 hour test run of `sadcloud` generated a bill of approximately $10. The majority of that cost is from the Redshift module (25c/hour = $6/day) and EKS module (10c/hour = $2.40/day).

## Sample Audits using sadcloud

We periodically use `sadcloud` to demonstrate various AWS and terraform auditing tooling. All audits are against the full corpus of possible misconfigurations.


| Tool  | Sample Report |
| ------------- | ------------- |
| [ScoutSuite](https://github.com/nccgroup/ScoutSuite)  | https://ramimac.github.io/sadcloud-reports/scoutsuite-reports/scoutsuite-report_03_2020/aws.html  |
| [prowler](https://github.com/toniblyx/prowler)  | https://ramimac.github.io/sadcloud-reports/prowler-report/report.html  |
|[cloudmapper](https://github.com/duo-labs/cloudmapper) |https://ramimac.github.io/sadcloud-reports/cloudmapper-reports/web_03_2020/account-data/report.html |
|[cloudsploit](https://github.com/cloudsploit/scans) | https://ramimac.github.io/sadcloud-reports/cloudsploit-scans-reports/scans.04_2020.txt |
| [tfsec](https://github.com/liamg/tfsec) | https://ramimac.github.io/sadcloud-reports/tfsec/tfsec.03_27_2020.txt |

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

```sh
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


* To enable all findings in one or more services:
  1. Uncomment the relevant service(s) in `sadcloud/main.tf`
  2. For a single service, either edit the relevant `all_{service}_findings` flag in `sadcloud/terraform.tfvars` to `true`, or call `terraform apply` with the flag `--var="all_{service}_findings=true"`
  3. For multiple services, either edit the `all_findings` flag in `sadcloud/terraform.tfvars` to `true`, or call `terraform apply` with the flag `--var="all_findings=true"`
  **NOTE: There is currently a [Terraform bug with the Cloudformation service](https://github.com/terraform-providers/terraform-provider-aws/issues/545). To generate Cloudformation findings, you will need to run `Terraform apply` twice**

* To enable specific findings granularly:
  1. Uncomment the relevant service in `sadcloud/main.tf`
  2. Edit the variables of interest directly in `sadcloud/main.tf`, flipping them to `true` where desired.
  3. For services that require a VPC, make sure you set `needs_network` to `true` in `sadcloud/main.tf`

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

```hcl
provider "aws" {
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
  region     = "us-east-1"
}
```
