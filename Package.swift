// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GCDWebServer",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9),
        .macOS(.v10_10),
    ],
    products: [
        // 对应 podspec 的 Core subspec（default_subspec）
        .library(
            name: "GCDWebServer",
            targets: ["GCDWebServer"]
        ),
        // 对应 podspec 的 WebDAV subspec
        .library(
            name: "GCDWebDAVServer",
            targets: ["GCDWebDAVServer"]
        ),
        // 对应 podspec 的 WebUploader subspec
        .library(
            name: "GCDWebUploader",
            targets: ["GCDWebUploader"]
        ),
    ],
    targets: [
        .target(
            name: "GCDWebServer",
            path: "GCDWebServer",
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedFramework("CFNetwork", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("CoreServices", .when(platforms: [.iOS, .tvOS])),
                .linkedFramework("SystemConfiguration", .when(platforms: [.macOS])),
            ]
        ),
        .target(
            name: "GCDWebDAVServer",
            dependencies: ["GCDWebServer"],
            path: "GCDWebDAVServer",
            linkerSettings: [
                .linkedLibrary("xml2"),
            ]
        ),
        .target(
            name: "GCDWebUploader",
            dependencies: ["GCDWebServer"],
            path: "GCDWebUploader",
            resources: [
                .copy("GCDWebUploader.bundle"),
            ]
        ),
    ]
)
