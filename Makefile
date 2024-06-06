PROJECT ?= radxa-desktop-branding
PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(PREFIX)/share/man
ETCDIR ?= /etc

.PHONY: all
all: build deb

.PHONY: build
build:
	./gen-wallpapers.sh
#
# Test
#
.PHONY: test
test:

#
# Clean
#
.PHONY: distclean
distclean: clean

.PHONY: clean
clean: clean-deb


.PHONY: clean-deb
clean-deb:
	rm -rf debian/.debhelper debian/radxa-desktop-branding/ debian/debhelper-build-stamp debian/files debian/*.debhelper.log debian/*.postrm.debhelper debian/*.substvars src/radxa-theme/wallpapers/

#
# Release
#
.PHONY: dch
dch: debian/changelog
	EDITOR=true gbp dch --commit --debian-branch=main --release --dch-opt=--upstream 

.PHONY: deb
deb: build debian
	debuild --no-lintian --lintian-hook "lintian --fail-on error,warning --suppress-tags bad-distribution-in-changes-file -- %p_%v_*.changes" --no-sign -b

.PHONY: release
release:
	gh workflow run .github/workflows/new_version.yml
