.PHONY: help check-shell tree

help:
	@printf '%s\n' \
	  'Nuroneko development targets:' \
	  '  make check-shell  Syntax-check shell scripts' \
	  '  make tree         Show repository structure'

check-shell:
	@find bin scripts installer -type f \
	  \( -name '*.sh' -o -name '*.bash' \) \
	  -exec bash -n {} +
	@echo 'Shell syntax check complete.'

tree:
	@tree -a -I '.git'
