# claude-config - portable Claude Code setup
# Run `make` for the target list.

CLAUDE_HOME ?= $(HOME)/.claude
SHELL       := /usr/bin/env bash

.DEFAULT_GOAL := help
.PHONY: help install link sync check lint template secrets stats clean-backups

help: ## Show this help
	@grep -hE '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) \
	  | awk 'BEGIN{FS=":.*?## "}{printf "  \033[1m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Copy skills/agents/commands/hooks into $(CLAUDE_HOME)
	@./install.sh

link: ## Symlink skills/agents/commands/hooks into $(CLAUDE_HOME)
	@./install.sh --link

sync: ## Pull $(CLAUDE_HOME) changes back into this repo
	@./sync-from-local.sh

check: lint template secrets ## Run every validation gate

lint: ## Validate skill, agent, and command frontmatter
	@python3 scripts/validate.py

template: ## Verify settings.template.json stays placeholder-only
	@python3 scripts/check-template.py

secrets: ## Fail if a credential pattern appears in tracked files
	@bash scripts/scan-secrets.sh

stats: ## Print inventory counts
	@printf 'skills    %s\n' "$$(ls -d skills/*/ 2>/dev/null | wc -l | tr -d ' ')"
	@printf 'agents    %s\n' "$$(ls agents/*.md 2>/dev/null | wc -l | tr -d ' ')"
	@printf 'commands  %s\n' "$$(ls commands/*.md 2>/dev/null | wc -l | tr -d ' ')"
	@printf 'hooks     %s\n' "$$(ls hooks/* 2>/dev/null | wc -l | tr -d ' ')"

clean-backups: ## Remove import backups this repo's installer created
	@rm -rf "$(CLAUDE_HOME)"/backups/config-import-* && echo "removed config-import backups"
