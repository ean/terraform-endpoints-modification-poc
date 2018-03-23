run: protoc_output.pb
	-[ ! -d .terraform ] && terraform init
	terraform apply -auto-approve
	@echo Next terraform command should not modify anything
	terraform apply

protoc_output.pb: bookstore.proto
	protoc --include_imports  bookstore.proto --descriptor_set_out protoc_output.pb

bookstore.proto:
	curl -s -O https://raw.githubusercontent.com/GoogleCloudPlatform/python-docs-samples/master/endpoints/bookstore-grpc/bookstore.proto

.PHONY: all bookstore.proto run
