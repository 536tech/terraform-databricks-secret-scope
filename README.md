# Databricks secret scope Terraform module

One secret scope.

Creates one secret scope, optionally backed by Azure Key Vault, and one `databricks_secret_acl` per entry in `acls`. The module never holds secret values.

## Resources

- `databricks_secret_scope.this`
- `databricks_secret_acl.this["<principal>"]` (one per entry in `acls`)

The resource addresses above are part of the DataTF import contract. Do not rename them.

## Usage

```hcl
module "secret_scope" {
  source  = "536tech/secret-scope/databricks"
  version = "1.0.0"

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
```

## Compatibility

Configure the Databricks provider in the calling root with a workspace endpoint.
This resource module is also used by the
[workspace pattern module](https://registry.terraform.io/modules/536tech/workspace/databricks/latest).
Each repository has its own releases. Consumers select an exact tested module version.

The resource addresses match the original workspace submodule in version 0.1.1.
To migrate a direct submodule call, change its source and version. Keep the module block name.
Run `terraform init` and require a plan with no resource changes.
DataTF exports continue to use the workspace pattern module and its existing import addresses.

## Development

Use Terraform 1.7 or later for the mock tests. The module supports Terraform 1.5 or later.

```sh
prek install
terraform init -backend=false -lockfile=readonly
terraform validate
terraform test
tflint --recursive
prek run --all-files
```

CI tests the committed provider version and the minimum supported provider, 1.128.0.
The workspace pattern module checks the complete DataTF contract and its integration behavior.

## License

[Apache-2.0](LICENSE).

## Input safeguards

The module rejects blank required names and invalid access inputs during the plan.
Cross-input preconditions preserve the Terraform 1.5 minimum and existing resource addresses.
Provider and API checks still apply. These checks do not prove complete permission visibility.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_secret_acl.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_acl) (resource)
- [databricks_secret_scope.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_scope) (resource)

## Required Inputs

The following input variables are required:

### name

Description: Secret scope name.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### acls

Description: Secret ACLs. Shape: principal -> permission (READ, WRITE, or MANAGE).

Type: `map(string)`

Default: `null`

### keyvault\_metadata

Description: Azure Key Vault that backs the scope.

Type:

```hcl
object({
    resource_id = string
    dns_name    = string
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### id

Description: Secret scope id.

### name

Description: Secret scope name.
<!-- END_TF_DOCS -->
