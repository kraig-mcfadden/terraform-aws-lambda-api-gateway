.PHONY: default
default:
	terraform init -backend=false
	terraform validate
	rm .terraform.lock.hcl
	terraform fmt --recursive
	terraform-docs markdown --output-file README.md .
	terraform-docs markdown --output-file README.md ./lambda
