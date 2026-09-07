mock_provider "databricks" {}

variables {

  name = "kv-scope"

  keyvault_metadata = {
    resource_id = "/subscriptions/.../vaults/kv-data"
    dns_name    = "https://kv-data.vault.azure.net/"
  }

  acls = {
    admins         = "MANAGE"
    data-engineers = "READ"
  }
}

run "documented_example" {
  command = apply

  assert {
    condition     = databricks_secret_scope.this.name == var.name
    error_message = "The resource must preserve its configured name."
  }

  assert {
    condition     = length(databricks_secret_acl.this) == length(var.acls)
    error_message = "Configured access must have stable resource addresses."
  }
}

run "without_access" {
  command = plan

  variables {
    acls = {}
  }

  assert {
    condition     = length(databricks_secret_acl.this) == 0
    error_message = "Empty access must omit the access resources."
  }
}
