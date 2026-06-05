// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// GCDWebUploader / GCDWebDAVServer 使用 #import "GCDWebServer.h" 等引号导入，
// CocoaPods subspec 会扁平化头文件搜索路径，SPM 需在 Package.swift 中显式补充。
let gcdWebServerCoreHeaderSearchPaths: [CSetting] = [
    .headerSearchPath("Core"),
    .headerSearchPath("Requests"),
    .headerSearchPath("Responses"),
]

let gcdWebServerDependentHeaderSearchPaths: [CSetting] = [
    .headerSearchPath("../GCDWebServer/Core"),
    .headerSearchPath("../GCDWebServer/Requests"),
    .headerSearchPath("../GCDWebServer/Responses"),
]

let package = Package(
    name: "GCDWebServer",
    platforms: [
        .iOS(.v12),
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
            publicHeadersPath: ".",
            cSettings: gcdWebServerCoreHeaderSearchPaths,
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
            publicHeadersPath: ".",
            cSettings: gcdWebServerDependentHeaderSearchPaths,
            linkerSettings: [
                .linkedLibrary("xml2"),
            ]
        ),
        .target(
            name: "GCDWebUploader",
            dependencies: ["GCDWebServer"],
            path: "GCDWebUploader",
            resources: [
                .copy("../Bundles/GCDWebUploader.bundle"),
            ],
            publicHeadersPath: ".",
            cSettings: gcdWebServerDependentHeaderSearchPaths
        ),
    ]
)
