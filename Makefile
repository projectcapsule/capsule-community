git := $(shell command -v git 2>/dev/null)
vim := $(shell command -v vim 2>/dev/null)

git_remote ?= origin

PREVIOUS_MONTH := ./meeting-notes/$(shell date +%Y)-$(shell date -d'last month' '+%m').md
THIS_MONTH := ./meeting-notes/$(shell date +%Y-%m).md
GIT_BRANCH := archive/meeting-$(shell date '+%y%m%d')

archive:
	$(git) checkout -b $(GIT_BRANCH)
	@test -f $(THIS_MONTH) \
		&& $(vim) $(THIS_MONTH) || \
		{ cp $(PREVIOUS_MONTH) $(THIS_MONTH) \
			&& $(vim) $(THIS_MONTH); }
	@$(git) add $(THIS_MONTH) && \
		$(git) commit -sm 'add notes for meeting of $(shell date +%Y-%m-%d)' && \
		$(git) push -u $(git_remote) $(GIT_BRANCH)

cleanup:
	$(git) checkout main
	$(git) branch -D $(GIT_BRANCH)
	rm -f $(THIS_MONTH)
