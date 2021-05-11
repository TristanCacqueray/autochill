.PHONY: install
install:
	mkdir -p ~/.local/share/gnome-shell/extensions/
	ln -s $(PWD)/dist/ ~/.local/share/gnome-shell/extensions/autochill@tristancacqueray.github.io

.PHONY: test
test:
	dbus-run-session -- gnome-shell --nested --wayland

.PHONY: dist
dist: dist-meta dist-extension dist-prefs

.PHONY: dist-meta
dist-meta:
	mkdir -p dist/schemas
	dhall-to-json --file ./src/metadata.dhall --output dist/metadata.json
	dhall text --file ./src/autochill.gschema.dhall --output dist/schemas/autochill.gschema.xml
	glib-compile-schemas dist/schemas/

.PHONY: dist-extension
dist-extension:
	spago bundle-app -m AutoChill --to dist/extension.js
	cat src/main-extension.js >> dist/extension.js

.PHONY: dist-prefs
dist-prefs:
	spago bundle-app -m AutoChill.Prefs --to dist/prefs.js
	cat src/main-prefs.js >> dist/prefs.js
