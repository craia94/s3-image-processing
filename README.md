# s3-image-processing
Terraform to deploy solution for S3 image processing.

Any .jpg files uploaded to bucket A will be processed by the image processor lambda. The lambda will remove any exif meta data and move the file to bucket B.

## Architecture
![architecture diagram](./assets/architecture-diagram.png)

## Usage

Before running the terraform we need to create a key for encrypting IAM access keys.
You will need to install gpg if you don't have it already.

Generate a key by running: `gpg --gen-key`
Output contents of public key to file: `gpg --output public-key-binary.gpg --export <your-email/identity-used-during-key-gen>`
Ensure public-key-binary.gpg is in the root directory of the terraform directory. If you move it somewhere else then you will need to update the variable `pgp_key_path` in env/dev.tfvars.

Initialize: `terraform init`
To run plan: `terraform plan -var-file="env/dev.tfvars"`
To deploy: `terraform apply -var-file="env/dev.tfvars"`
To destroy: `terraform destroy -var-file="env/dev.tfvars"`

To check output value of access keys (example of user_a key): `terraform output -raw user_a_secret_key | base64 --decode | gpg --decrypt`