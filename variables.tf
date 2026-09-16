variable "name" {
  description = "Secret scope name."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.name)) > 0, false)
    error_message = "name must not be empty or blank."
  }
}

variable "acls" {
  description = "Secret ACLs. Shape: principal -> permission (READ, WRITE, or MANAGE)."
  type        = map(string)
  default     = null
  validation {
    condition = var.acls == null ? true : try(alltrue([for principal, permission in var.acls :
      length(trimspace(principal)) > 0 && contains(["READ", "WRITE", "MANAGE"], permission)
    ]), false)
    error_message = "Each ACL needs a nonblank principal and READ, WRITE, or MANAGE permission."
  }
}

variable "keyvault_metadata" {
  description = "Azure Key Vault that backs the scope."

  type = object({
    resource_id = string
    dns_name    = string
  })

  default = null
}
