# BBTestAppBundleIdentifiers

I built this sample repo for a customer to demonstrate best practices when using multiple schemes, multiple Apple accounts (regular & enterprise), multiple targets (watch app, iMessage extension, and framework) all in the same project.

In this scenario getting the bundle ids right can be tricky. Here each build configuration has an .xcconfig that sets BASE_BUNDLE_IDENTIFIER to a unique value.

Then every other usage of bundle identifiers in the projects derives from this value, but there is no other per-configuration variation. So the differences between the various build configurations are entirely captured by the .xcconfig files.

You can view the build in buddybuild here (or fork it and sign it up yourself):
https://dashboard.buddybuild.com/public/apps/588178b460f9a701005a4d7f/build/58817bf01a53a00100c246a5
