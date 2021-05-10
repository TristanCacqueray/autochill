.PHONY: test-prefs
test-prefs:
	spago bundle-app -m AutoChill.Prefs --to build/prefs.js --then "gjs build/prefs.js"
