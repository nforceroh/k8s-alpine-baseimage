#!/usr/bin/make -f

SHELL := /bin/bash
IMG_NAME := k8s-alpine-baseimage
IMG_REPO := nforceroh
DOCKERCMD := docker

.PHONY: all build push gitcommit gitpush create
all: build push 
git: gitcommit gitpush 

build: 
	@echo "Building $(IMG_NAME)image"
	$(DOCKERCMD) build \
		--tag $(IMG_REPO)/$(IMG_NAME) .

push: 
	@echo "Tagging and Pushing $(IMG_NAME):$(VERSION) image"
	$(DOCKERCMD) tag $(IMG_REPO)/$(IMG_NAME) docker.io/$(IMG_REPO)/$(IMG_NAME):latest
	$(DOCKERCMD) push docker.io/$(IMG_REPO)/$(IMG_NAME):latest

end:
	@echo "Done!"