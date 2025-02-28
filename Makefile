PREFIX ?= /usr/local/sbin
INSTALL ?= install
INSTALL_PROGRAM ?= $(INSTALL) -m 755
INSTALL_DATA ?= $(INSTALL) -m 644

.PHONY: all install uninstall clean

all:
	@echo "Available commands:"
	@echo "  make install   - Install openhands runner"
	@echo "  make uninstall - Uninstall openhands runner"

install:
	@echo "Installing openhands runner..."
	$(INSTALL) -d $(PREFIX)
	$(INSTALL_PROGRAM) scripts/run_openhands.sh $(PREFIX)/openhands
	@echo "Installation complete. You can now use 'openhands' command"

uninstall:
	@echo "Uninstalling openhands runner..."
	rm -f $(PREFIX)/openhands
	@echo "Uninstallation complete"

clean:
	@echo "Nothing to clean"