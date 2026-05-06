.PHONY: style test

_analyze_flutter:
	flutter analyze

_analyze_metrics:
	dart run dart_code_linter:metrics analyze . --set-exit-on-violation-level=warning

style:
	dart format lib
	$(MAKE) -j2 _analyze_flutter _analyze_metrics

test:
	flutter test --test-randomize-ordering-seed=$(or $(seed),random)
