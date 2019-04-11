#This makefile is used by ci-operator

CGO_ENABLED=0
GOOS=linux
CORE_IMAGES=./cmd/activator ./cmd/autoscaler ./cmd/controller ./cmd/queue ./cmd/webhook
TEST_IMAGES=$(shell find ./test/test_images -mindepth 1 -maxdepth 1 -type d) ./test/controller

install:
	go install $(CORE_IMAGES)
.PHONY: install

test-install:
	for img in $(TEST_IMAGES); do \
		go install $$img ; \
	done
.PHONY: test-install

test-e2e:
	./openshift/e2e-tests-openshift.sh
.PHONY: test-e2e

# Generate Dockerfiles for core and test images used by ci-operator. The files need to be committed manually.
generate-dockerfiles:
	./openshift/ci-operator/generate-dockerfiles.sh openshift/ci-operator/knative-images $(CORE_IMAGES)
	./openshift/ci-operator/generate-dockerfiles.sh openshift/ci-operator/knative-test-images $(TEST_IMAGES)
.PHONY: generate-dockerfiles

# Generates a ci-operator configuration for a specific branch.
generate-ci-config:
	./openshift/ci-operator/generate-ci-config.sh $(BRANCH) > ci-operator-config.yaml
.PHONY: generate-ci-config

# Generate an aggregated knative yaml file with replaced image references
generate-release:
	./openshift/release/generate-release.sh $(RELEASE)
.PHONY: generate-release
