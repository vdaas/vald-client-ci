
# NOTE:
# The version of the local action inside the setup-language action also changes, so it is excluded from the `find` command.
# As this is a special case, it was discussed to exclude it from the `find` command without using `sed` command to deal with it.

define update-github-actions
	@set -e; for ACTION_NAME in $1; do \
		if [ -n "$$ACTION_NAME" ] && [ "$$ACTION_NAME" != "security-and-quality" ]; then \
			FILE_NAME=`echo $$ACTION_NAME | tr '/' '_' | tr '-' '_' | tr '[:lower:]' '[:upper:]'`; \
			if [ -n "$$FILE_NAME" ]; then \
				if [ "$$ACTION_NAME" = "aquasecurity/trivy-action" ] || [ "$$ACTION_NAME" = "machine-learning-apps/actions-chatops" ]; then \
					VERSION="master"; \
				else \
					REPO_NAME=`echo $$ACTION_NAME | cut -d'/' -f1-2`; \
					VERSION=`curl -fsSL https://api.github.com/repos/$$REPO_NAME/releases/latest | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/v//g' | sed -E 's/[^0-9.]+//g'`;\
				fi; \
				if [ -n "$$VERSION" ]; then \
					OLD_VERSION=`cat $(ROOTDIR)/versions/$$FILE_NAME`; \
					echo "updating $$ACTION_NAME version file $$FILE_NAME from $$OLD_VERSION to $$VERSION"; \
					echo $$VERSION > $(ROOTDIR)/versions/$$FILE_NAME; \
				else \
					VERSION=`cat $(ROOTDIR)/versions/$$FILE_NAME`; \
					echo "No version found for $$ACTION_NAME version file $$FILE_NAME=$$VERSION"; \
				fi; \
				if [ "$$ACTION_NAME" = "cirrus-actions/rebase" ]; then \
					VERSION_PREFIX=$$VERSION; \
					find $(ROOTDIR)/.github -type f -exec sed -i "s%$$ACTION_NAME@.*%$$ACTION_NAME@$$VERSION_PREFIX%g" {} +; \
				elif [ "$$ACTION_NAME" = "pypa/gh-action-pypi-publish" ]; then \
					# VERSION_PREFIX=`echo $$VERSION | sed -E "s%^([0-9]+)\..*$$%release/v\1%"`; \
					# find $(ROOTDIR)/.github -type f -exec sed -i "s%$$ACTION_NAME@.*%$$ACTION_NAME@$$VERSION_PREFIX%g" {} +; \
					echo "Lock pypa/gh-action-pypi-publish version to v1.11.0"; \
				elif echo $$VERSION | grep -qE '^[0-9]'; then \
					VERSION_PREFIX=`echo $$VERSION | cut -c 1`; \
					find $(ROOTDIR)/.github -type f -not -path "$(ROOTDIR)/.github/actions/setup-language/*" -exec sed -i "s%$$ACTION_NAME@.*%$$ACTION_NAME@v$$VERSION_PREFIX%g" {} +; \
				else \
					VERSION_PREFIX=$$VERSION; \
					find $(ROOTDIR)/.github -type f -exec sed -i "s%$$ACTION_NAME@.*%$$ACTION_NAME@$$VERSION_PREFIX%g" {} +; \
				fi; \
			else \
				echo "No action version file found for $$ACTION_NAME version file $$FILE_NAME" >&2; \
			fi \
		else \
			echo "No action found for $$ACTION_NAME" >&2; \
		fi \
	done
endef
