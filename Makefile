.PHONY: fmt validate lint scan docs init-all

fmt:
	terraform fmt -recursive terraform

validate:
	bash scripts/validate-all.sh

lint:
	tflint --chdir=terraform/modules/vpc --init || true
	@echo "Run tflint per module (see scripts/validate-all.sh)"

scan:
	checkov -d terraform --config-file security/checkov-config.yml || true

docs:
	@echo "Docs are in docs/. See README roadmap table."

bootstrap:
	bash scripts/bootstrap-state-backend.sh
