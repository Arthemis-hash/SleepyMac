// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SleepBabySleep",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "SleepBabySleep",
            path: "SleepBabySleep",
            exclude: [
                "Resources/Assets.xcassets",
                "Resources/Info.plist",
                "Resources/SleepMac.icns",
                "SleepBabySleep.entitlements"
            ],
            linkerSettings: [
                .linkedFramework("IOKit"),
                .linkedFramework("SwiftUI"),
                .linkedFramework("AppKit"),
                .linkedFramework("UserNotifications"),
                .linkedFramework("ServiceManagement")
            ]
        ),
        .testTarget(
            name: "SleepBabySleepTests",
            dependencies: ["SleepBabySleep"],
            path: "SleepBabySleepTests"
        )
    ]
)
