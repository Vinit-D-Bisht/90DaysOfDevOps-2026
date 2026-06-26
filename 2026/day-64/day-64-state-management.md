## Local State vs Remote State

```bash
flowchart TD
    Terraform["Terraform Configuration"]
    Apply["terraform apply"]

    Terraform --> Apply
    Apply --> Local["Local State<br/>terraform.tfstate"]
    Apply --> Remote["Remote State"]

    Remote --> S3["Amazon S3"]
    Remote --> DynamoDB["DynamoDB (State Locking)"]
```

### Local State

- Stored on your local machine.
- State file: `terraform.tfstate`
- Best for personal projects and learning.
- Does not support state locking.
- Not suitable for team collaboration.

### Remote State

- Stored in a remote backend such as Amazon S3.
- Uses DynamoDB for state locking.
- Allows multiple team members to work safely.
- More secure and reliable than local state.

---

## Steps I Followed for `terraform import`

1. Created the resource manually in AWS.
2. Added the same resource block in `main.tf`.
3. Imported the existing resource into Terraform.

```bash
terraform import aws_s3_bucket.my_bucket my-demo-bucket
```

4. Verified the import.

```bash
terraform plan
```

### Result

- The resource was added to the Terraform state.
- Terraform started managing the existing AWS resource.
- `terraform plan` showed no changes after the configuration matched the imported resource.

---

## What is State Drift?

State drift occurs when the actual infrastructure is changed outside of Terraform, causing the Terraform state to differ from the real infrastructure.

### My Example

1. Created an S3 bucket using Terraform.
2. Modified the bucket manually from the AWS Management Console.
3. Ran:

```bash
terraform plan
```

Terraform detected the differences between the state file and the actual infrastructure and displayed the changes required to bring the infrastructure back to the desired state.

---

## Terraform State Commands

### `terraform state mv`

Moves or renames a resource in the Terraform state without recreating it.

**Example:**

```bash
terraform state mv aws_s3_bucket.old aws_s3_bucket.new
```

---

### `terraform state rm`

Removes a resource from the Terraform state without deleting it from AWS.

**Example:**

```bash
terraform state rm aws_s3_bucket.my_bucket
```

---

### `terraform import`

Imports an existing resource into the Terraform state so Terraform can manage it.

**Example:**

```bash
terraform import aws_s3_bucket.my_bucket my-demo-bucket
```

---

### `terraform force-unlock`

Removes a stale state lock after a failed or interrupted Terraform operation.

**Example:**

```bash
terraform force-unlock LOCK_ID
```

---

### `terraform refresh`

Updates the Terraform state file with the latest information from the actual infrastructure.

**Example:**

```bash
terraform refresh
```
