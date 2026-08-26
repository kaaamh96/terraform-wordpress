
# AWS Custom VPC & WordPress Infrastructure with Terraform

A hands-on Infrastructure as Code (IaC) project demonstrating how to design and provision a custom, production-ready AWS network architecture from scratch and deploy a WordPress instance using Terraform.

---

## Architecture Overview

```text
                               +-------------------------------------------------+
                               |                   AWS Cloud                     |
                               |                                                 |
                               |   +-----------------------------------------+   |
                               |   |              Custom VPC                 |   |
                               |   |                                         |   |
  +------------------+         |   |   +---------------------------------+   |   |
  |   User / Client  | --------|---|-->|        Internet Gateway         |   |   |
  +------------------+         |   |   +---------------------------------+   |   |
                               |   |                    |                    |   |
                               |   |             +--------------+            |   |
                               |   |             | Route Table  |            |   |
                               |   |             +--------------+            |   |
                               |   |                    |                    |   |
                               |   |   +---------------------------------+   |   |
                               |   |   |          Public Subnet          |   |   |
                               |   |   |                                 |   |   |
                               |   |   |   +-------------------------+   |   |   |
                               |   |   |   |     Security Group      |   |   |   |
                               |   |   |   |                         |   |   |   |
                               |   |   |   |   +-----------------+   |   |   |   |
                               |   |   |   |   |  EC2 Instance   |   |   |   |   |
                               |   |   |   |   |  (WordPress +   |   |   |   |   |
                               |   |   |   |   |   Apache/MySQL) |   |   |   |   |
                               |   |   |   |   +-----------------+   |   |   |   |
                               |   |   |   +-------------------------+   |   |   |
                               |   |   +---------------------------------+   |   |
                               |   |                    |                    |   |
                               |   |   +---------------------------------+   |   |
                               |   |   |         Private Subnet          |   |   |
                               |   |   |   (Isolated for future DB/App)  |   |   |
                               |   |   +---------------------------------+   |   |
                               |   +-----------------------------------------+   |
                               +-------------------------------------------------+
```

---

## What I Built

- **Custom AWS VPC:** Designed a dedicated Virtual Private Cloud with custom CIDR block allocations.
- **Subnetting Strategy:** Segmented public and private subnets across Availability Zones for traffic isolation.
- **Internet Access & Routing:** Configured an Internet Gateway (IGW) and custom Route Tables to control network routing.
- **Network Security:** Defined AWS Security Groups as stateful firewalls to expose only required ports (HTTP `80`, SSH `22`).
- **Application Deployment:** Provisioned an AWS EC2 instance bootstrap-configured to run a WordPress web stack.
- **Automated Infrastructure:** Entire setup managed, provisioned, and destroyed using standard Terraform declarative workflows.

---

## Key Concepts Demonstrated

- **Infrastructure as Code (IaC):** Writing modular, version-controlled cloud infrastructure using HCL (HashiCorp Configuration Language).
- **AWS Cloud Networking:** VPC architecture, CIDR block design, public vs. private subnet isolation, and route management.
- **Security & Access Control:** Least-privilege access rules implemented via Security Group configurations.
- **Automated Bootstrapping:** Utilizing EC2 `user_data` scripts to initialize application dependencies automatically on boot.

---

## Repository Structure

```text
.
├── main.tf          # Core infrastructure definitions (VPC, Subnets, EC2, Security Groups)
├── variables.tf     # Input variables for customization (Regions, CIDR blocks, Instance types)
├── outputs.tf       # Exported values (Public IP, VPC ID, Subnet IDs)
├── providers.tf     # AWS Provider setup and version locking
└── README.md        # Project documentation
```

---

## Getting Started

### Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (v1.0+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with proper IAM permissions
- An active AWS Account

### Deployment Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kaaamh96/terraform-wordpress.git
   cd YOUR-REPO-NAME
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Preview resources to be created:**
   ```bash
   terraform plan
   ```

4. **Provision the infrastructure:**
   ```bash
   terraform apply
   ```

5. **Access WordPress:**
   Copy the `wordpress_public_ip` output and navigate to it in your web browser:
   ```text
   http://<YOUR_EC2_PUBLIC_IP>
   ```

### Clean Up

To avoid unnecessary AWS charges, tear down all created resources:
```bash
terraform destroy
```










