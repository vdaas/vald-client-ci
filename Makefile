
ROOTDIR := $(shell git rev-parse --show-toplevel)
ACTIONS_GREP_OUTPUT := $(shell grep --include=\*.{yml,yaml} -rohE 'uses: .+' .github/ > /tmp/actions_grep_output.txt && cat /tmp/actions_grep_output.txt)
ACTIONS_LIST := $(shell awk '!/\.github/ && !seen[$$0]++ {sub(/@.*/, "", $$0); print substr($$0, 7)}' /tmp/actions_grep_output.txt > /tmp/actions_list.txt && cat /tmp/actions_list.txt)

.PHONY: list/actions
## show variation of external actions
list/actions:
	@grep --include=\*.{yml,yaml} -rohE 'uses: .+' .github/ > /tmp/actions_grep_output.txt
	@echo "Grep output:"
	@cat /tmp/actions_grep_output.txt
	@awk '!/\.github/ && !seen[$$0]++ {sub(/@.*/, "", $$0); print substr($$0, 7)}' /tmp/actions_grep_output.txt > /tmp/actions_list.txt
	@echo "Actions list:"
	@cat /tmp/actions_list.txt


.PHONY: update/actions
# update github actions version
update/actions:
	@echo aaaaa

# ROOTDIR = $(eval ROOTDIR := $(or $(shell git rev-parse --show-toplevel), $(PWD)))$(ROOTDIR)
#
# # ACTIONS_LIST := $(eval ACTIONS_LIST := $(shell grep --include=\*.{yml,yaml} -rohE 'uses: .+' .github/ | awk '!/\.github/ && !seen[$$0]++ {sub(/@.*/, "", $$0); print substr($$0, 7)}'))$(ACTIONS_LIST)
# ACTIONS_LIST := $(shell grep --include=\*.{yml,yaml} -rohE 'uses: .+' .github/ | awk '!/\.github/ && !seen[$$0]++ {sub(/@.*/, "", $$0); print substr($$0, 7)}')
#
# # ACTIONS_LIST := $(shell grep --include=\*.{yml,yaml} -rohE 'uses: .+' $(ROOTDIR)/.github/ | awk '!/\.github/ && !seen[$$0]++ {sub(/@.*/, "", $$0); print substr($$0, 7)}')
# # ACTIONS_LIST := $(shell grep --include=\*.{yml,yaml} -rohE 'uses: .+' $(ROOTDIR)/.github/)
#
# include Makefile.d/function.mk
#
# .PHONY: list/actions
# ## show variation of external actions
# list/actions:
# 	@echo $(ACTIONS_LIST)
#
# .PHONY: update/actions
# # update github actions version
# update/actions:
# 	$(call update-github-actions, $(ACTIONS_LIST))
