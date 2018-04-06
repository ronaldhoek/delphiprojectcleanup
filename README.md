Delphi project cleanup
======================

Starting with Delphi XE the project tends te become less manageble from within the IDE.

This has mainly to do with the that different build configuratioins are available within the project file (like release, debug, differente OS's, etc.) ANd the fact is uses an inherited system for setting different settings for these different build configurations.

But also the version information is part of the inheritence system.
However, this makes setting version information a bit hard to manage.

This tool wil cleanup several configuration overrides, so you can easily manage these settings from the 'All configurations' build configuration entry inside the IDE.
