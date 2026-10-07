# Xcode 26.5 goldens

Apple ibtool 26.5 output for `../src/Expo/*.storyboard`, compiled on a Mac with
the flags Xcode uses for an Expo app's launch storyboard:

    xcrun ibtool --errors --warnings --notices --module Teatime \
      --output-partial-info-plist P.plist --auto-activate-custom-fonts \
      --target-device iphone --target-device ipad \
      --minimum-deployment-target 16.4 --output-format human-readable-text \
      X.storyboard --compilation-directory OUT

The deployment target (16.4 or 17.0) does not change these files, and the module
only matters for custom classes, which these storyboards have none of.
`SplashScreen.storyboardc` is also byte-identical to the one in Teatime's
Xcode-built archive. `SplashScreen.storyboard` is the file `expo prebuild -p ios`
writes for Teatime; the other two are variants of it (no constraints; no
`storyboardIdentifier`). `tools/ibtool --self-test` compares against these with
`OAD_IBTOOL_XCODE_MAJOR=26` semantics (FINDINGS 63).
