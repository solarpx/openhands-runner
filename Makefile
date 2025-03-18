PREFIX ?= /usr/local/bin
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
        @# Remove old installation from sbin if it exists
        @if [ -f /usr/local/sbin/openhands ]; then \
                echo "Removing old installation from /usr/local/sbin..."; \
                rm -f /usr/local/sbin/openhands; \
        fi
        $(INSTALL) -d $(PREFIX)
        $(INSTALL_PROGRAM) scripts/run_openhands.sh $(PREFIX)/openhands
        @echo "Installation complete. You can now use 'openhands' command"

uninstall:
        @echo "Uninstalling openhands runner..."
        rm -f $(PREFIX)/openhands
        @# Remove from old location if it exists
        @if [ -f /usr/local/sbin/openhands ]; then \
                echo "Removing old installation from /usr/local/sbin..."; \
                rm -f /usr/local/sbin/openhands; \
        fi
        @echo "Uninstallation complete"

clean:
        @echo "Nothing to clean"