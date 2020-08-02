SWIFT_BUILD_FLAGS=--configuration release

.PHONY: all build clean xcode

all: fix_bad_header_files build
	
fix_bad_header_files:
	-@find  . -name '._*.h' -exec rm {} \;

build:
	swift build $(SWIFT_BUILD_FLAGS)

clean:
	rm -rf .build
	rm -rf .swiftpm

update:
	swift package update

test:
	swift test

run:
	swift run $(SWIFT_BUILD_FLAGS)

xcode:
	swift package generate-xcodeproj
