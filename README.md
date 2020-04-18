Steps:

1) Download terraform v0.12.24
2) Copy the files
3) Run in the root directory the command: terraform init
4) Run the command: terraform apply

Consider to set up properly the AWS files config and credentials in the .aws directory in your profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
And be sure that your profile have all privilegies to create resources.

The private key is stored in the subdirectory "computer", that file could be used to access the EC2 instances. This is useful to verify the execution of Celery.

Note. In the present repository was added the file terraform.tfstate.backup as evidence of previous runs. That file could be deleted safely.
