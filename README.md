# BBTestAppBundleIdentifiers

I built this sample repo for various customers to demonstrate best practices when using multiple schemes, multiple Apple accounts (regular & enterprise), multiple targets (watch app, iMessage extension, and framework), and also generating schemes on the fly all in the same project.

## Bundle Ids

In this scenario getting the bundle ids right can be tricky. Here each build configuration has an .xcconfig that sets BASE_BUNDLE_IDENTIFIER to a unique value.

Then every other usage of bundle identifiers in the projects derives from this value, but there is no other per-configuration variation. So the differences between the various build configurations are entirely captured by the .xcconfig files.

## Scheme generation

This project also shows how to generate new schemes that are based on an existing build configuration and
are defined through an xcconfig file

There is a buddybuild_postclone.sh script that calls a ruby script, setups_schemes.rb. This script makes a new build configuration and scheme.

# View results

You can view the build in buddybuild here (or fork it and sign it up yourself):
https://dashboard.buddybuild.com/apps/58c663e22d1cd40100e2281f/build/58c6649fff97cb010033dab2#logs
