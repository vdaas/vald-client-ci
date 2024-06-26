SHELL=bash

ROOTDIR = $(eval ROOTDIR := $(or $(shell git rev-parse --show-toplevel), $(PWD)))$(ROOTDIR)

ACTIONS_LIST := $(shell grep --include=\*.{yml,yaml} -rohE 'uses: .+' .github/ | awk '!/\.github/ && !seen[$$0]++ {sub(/@.*/, "", $$0); print substr($$0, 7)}')

include Makefile.d/function.mk

.PHONY: list/actions
## show variation of external actions
list/actions:
	@echo $(ACTIONS_LIST)

.PHONY: update/actions
# update github actions version
update/actions:
	$(call update-github-actions, $(ACTIONS_LIST))
