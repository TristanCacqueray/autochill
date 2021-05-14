DIST := "autochill@tristancacqueray.github.io"

all: dist

.PHONY: install
install:
	mkdir -p ~/.local/share/gnome-shell/extensions/
	ln -s $(PWD)/autochill@tristancacqueray.github.io/ ~/.local/share/gnome-shell/extensions/autochill@tristancacqueray.github.io

.PHONY: test
test:
	dbus-run-session -- gnome-shell --nested --wayland

.PHONY: dist
dist: dist-meta dist-extension dist-prefs

.PHONY: dist-meta
dist-meta:
	mkdir -p $(DIST)/schemas
	dhall-to-json --file ./src/metadata.dhall --output $(DIST)/metadata.json
	dhall text --file ./src/autochill.gschema.dhall --output $(DIST)/schemas/autochill.gschema.xml
	glib-compile-schemas $(DIST)/schemas/

.PHONY: dist-extension
dist-extension:
	spago bundle-app -m AutoChill --to $(DIST)/extension.js
	cat src/main-extension.js >> $(DIST)/extension.js

.PHONY: dist-prefs
dist-prefs:
	spago bundle-app -m AutoChill.Prefs --to $(DIST)/prefs.js
	cat src/main-prefs.js >> $(DIST)/prefs.js
