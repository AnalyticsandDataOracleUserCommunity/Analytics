# Copyright (c) 2019, 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}

variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}

variable "public_ssh_key" {
  default = ""
}

# Compute
variable "num_nodes" {
  default = 2
}
variable "generate_public_ssh_key" {
  default = true
}
variable "instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}
variable "image_operating_system" {
  default = "Oracle Linux"
}
variable "image_operating_system_version" {
  default = "7.8"
}
variable "instance_visibility" {
  default = "Public"
}
variable "is_pv_encryption_in_transit_enabled" {
  default = false
}

# Network Details
variable "lb_shape" {
  default = "10Mbps-Micro"
}
variable "lb_compartment_ocid" {
  default = ""
}
variable "create_secondary_vcn" {
  default = false
}
variable "create_lpg_policies_for_group" {
  default = false
}
variable "user_admin_group_for_lpg_policy" {
  default = "Administrators"
}
variable "network_cidrs" {
  type = map(string)

  default = {
    MAIN-VCN-CIDR                  = "10.1.0.0/16"
    MAIN-SUBNET-REGIONAL-CIDR      = "10.1.21.0/24"
    SECONDARY-SUBNET-REGIONAL-CIDR = "10.1.22.0/24"
    MAIN-LB-SUBNET-REGIONAL-CIDR   = "10.1.23.0/24"
    LB-VCN-CIDR                    = "10.2.0.0/16"
    LB-SUBNET-REGIONAL-CIDR        = "10.2.22.0/24"
    ALL-CIDR                       = "0.0.0.0/0"
  }
}

# Encryption (OCI Vault/Key Management/KMS)
variable "use_encryption_from_oci_vault" {
  default = false
}
variable "create_new_encryption_key" {
  default = true
}
variable "encryption_key_id" {
  default = ""
}
variable "create_vault_policies_for_group" {
  default = false
}
variable "user_admin_group_for_vault_policy" {
  default = "Administrators"
}
variable "vault_display_name" {
  default = "TechCast Vault"
}
variable "vault_type" {
  type    = list
  default = ["DEFAULT", "VIRTUAL_PRIVATE"]
}
variable "vault_key_display_name" {
  default = "TechCast Key"
}
variable "vault_key_key_shape_algorithm" {
  default = "AES"
}
variable "vault_key_key_shape_length" {
  default = 32
}

# Always Free only or support other shapes
variable "use_only_always_free_elegible_resources" {
  default = true
}

# ORM Schema visual control variables
variable "show_advanced" {
  default = false
}
