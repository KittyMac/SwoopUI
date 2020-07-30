SWIFT_BUILD_FLAGS=--configuration release

.PHONY: all build clean xcode

all: fix_bad_header_files build
	
fix_bad_header_files:
	-@find  . -name '._*.h' -exec rm {} \;

build:
	swift build $(SWIFT_BUILD_FLAGS)

clean:
	rm -rf .build

update:
	swift package update

test:
	swift test

run:
	swift run

xcode:
	swift package generate-xcodeproj
