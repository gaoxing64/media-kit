// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let libmpvTargets = [
    "Ass",
    "Avcodec",
    "Avfilter",
    "Avformat",
    "Avutil",
    "Dav1d",
    "Freetype",
    "Fribidi",
    "Harfbuzz",
    "Mbedcrypto",
    "Mbedtls",
    "Mbedx509",
    "Mpv",
    "Png16",
    "Swresample",
    "Swscale",
    "Uchardet",
    "Xml2"
]

let libmpvArtifactBase = "https://github.com/gaoxing64/libmpv-darwin-build/releases/download/0.6.11/libmpv-xcframeworks_0.6.11_ios-universal-video-default"
let libmpvChecksums = [
    "Ass": "c6e2c57a2df07eab5373e01f2a2dd5eae33dfc3e7fcc9453171f77b6c5c8d510",
    "Avcodec": "a1be4ba9690bbd81a9446465e827930f890ca931c3a982861fa1fafb01c52187",
    "Avfilter": "cc2afa8102c1e2ea8cfd0335233f35a51b6433ee5118a595303c9b71dbe0621c",
    "Avformat": "108df23ae675ea88731e1e9f38b774cc3c7778a9ca1a4d632d4d1a642d2fa4eb",
    "Avutil": "4d74b4da274a2da6441151be05dd0d0f177796f724d015a4fdb87c52d749a8cb",
    "Dav1d": "6f3e13cbacc0f8fb5dbc9674f33ab2d2f3235f258e6536673470828f3b794b5b",
    "Freetype": "7d6dc9db91c1eca47bb083c2b7fdc966fca1dda1e4a35590bf898f7d57c8d2f5",
    "Fribidi": "2472b4ec28a9f06eb144c242bcb0cfcc843fbe7d6d57415727282bcc4b07c871",
    "Harfbuzz": "209c9d5c8384dd5b49617f43087a11d40e0390063ab9030f960e8f1771fd3f50",
    "Mbedcrypto": "db227ada5ec61c1850e5d06319b96dbe32d00f8a21be8d7c62ab879245526205",
    "Mbedtls": "d450b08df90406447d49fbefd50118c39e3b7d0f9f1ccbf1c22e54928e2ac269",
    "Mbedx509": "b4d779ee13c29afaf704c93b8df0f104eef6430ed6630425baab4ff1715469be",
    "Mpv": "c75830cb95edc00fb0cf344a4b1946a1f413b353abf7f513db1ef8d94b176176",
    "Png16": "f723befd48509d613926333a9a44e93b6d984e5e8e0586185ce14004d60974ac",
    "Swresample": "a7de4cc947fd5cafa36ff32f31bf922ca8b5816f1c58559575daba3125efba87",
    "Swscale": "1cfb2d249bebd954bcc8b702e0293c89f1de07307e4976ca01e7f0b6002ad9e3",
    "Uchardet": "f6fecd3705e416fc69e1045774aa1028e4e5c701f0ac7708ea63d0cc4303eb5f",
    "Xml2": "900ae4b85a59557e553a6c7fa0bb03ca5392ca2676c21247944c89ba05d5d10f"
]
let libmpvProductTargets: [String] = ["media_kit_libs_ios_video"] + libmpvTargets

let package = Package(
    name: "media_kit_libs_ios_video",
    platforms: [
        .iOS("9.0")
    ],
    products: [
        .library(name: "media-kit-libs-ios-video", targets: libmpvProductTargets),
        .library(name: "Mpv", targets: ["Mpv"])
    ],
    dependencies: [],
    targets: libmpvTargets.map { framework in
        .binaryTarget(
            name: framework,
            url: "\(libmpvArtifactBase)_\(framework).zip",
            checksum: libmpvChecksums[framework]!
        )
    } + [
        .target(
            name: "media_kit_libs_ios_video",
            dependencies: libmpvTargets.map { framework in .target(name: framework) },
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
