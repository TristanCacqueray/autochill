.PHONY: install
install:
	mkdir -p ~/.local/share/gnome-shell/extensions/
	ln -s $(PWD)/dist/ ~/.local/share/gnome-shell/extensions/autochill@tristancacqueray.github.io

.PHONY: test
test:
	dbus-run-session -- gnome-shell --nested --wayland

.PHONY: test-prefs
test-prefs:
	spago bundle-app -m AutoChill.Prefs --to build/prefs.js --then "gjs build/prefs.js"

.PHONY: dist
dist: dist-meta dist-extension dist-prefs

.PHONY: dist-meta
dist-meta:
	mkdir -p dist/schemas
	echo "(./src/metadata.dhall).metadata" | dhall-to-json --output dist/metadata.json
	dhall text --file ./src/autochill.gschema.dhall --output dist/schemas/autochill.gschema.xml
	glib-compile-schemas dist/schemas/

.PHONY: dist-extension
dist-extension:
	spago bundle-module -m AutoChill --to dist/extension.js
	# Add necessary function to make this a valid gnome extensions
	sed -e 's/^module.exports.*//' -i dist/extension.js
	cat src/main-extension.js >> dist/extension.js

.PHONY: dist-prefs
dist-prefs:
	spago bundle-module -m AutoChill.Prefs --to dist/prefs.js
	sed -e 's/^module.exports.*//' -i dist/prefs.js
	cat src/main-prefs.js >> dist/prefs.js
