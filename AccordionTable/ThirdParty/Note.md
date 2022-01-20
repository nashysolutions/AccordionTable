# Note

We include the source for [Ordered collections](https://github.com/apple/swift-collections/releases/tag/1.0.2) directly because we cannot setup an SPM dependency for it, without consequences (see reference links).

This target is not suitable for SPM as we require the scheme to fire UITests (which requires a host application).

References
* https://forums.swift.org/t/issue-with-third-party-dependencies-inside-a-xcframework-through-spm/41977
* https://forums.swift.org/t/host-application-for-spm-tests/24363
