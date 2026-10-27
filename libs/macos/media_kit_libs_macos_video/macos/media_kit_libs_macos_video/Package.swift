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

let libmpvArtifactBase = "https://github.com/gaoxing64/libmpv-darwin-build/releases/download/0.6.11/libmpv-xcframeworks_0.6.11_macos-universal-video-default"
let libmpvChecksums = [
    "Ass": "bfd7c269084ff001b7a75818009eb1480a05d478b389d10337b72c1239384fb4",
    "Avcodec": "7a055f00bf0065c51c7a7fed6248780d50374e5a2a505d4ba6281cc10b60a412",
    "Avfilter": "269451e160ca29c15dee8ff8caac212e59b875e619974f4ba1f75a7bec080325",
    "Avformat": "b63ca1683f19f9f2a66eaea12d8b842894c5f9c20c01641af623b687960acb2e",
    "Avutil": "b5df2db85087b292c154cc4b07e81ae30cf16c2bb2c1d35b4a537441cfda4f02",
    "Dav1d": "6f9298382376c78b4ce2e173117a8f660adc8000ee22619cfd716fbb326fc2e8",
    "Freetype": "2e7dc634d32997c802f9cf8d94a0f9a45a98cce7b5e94b8b0c989b9343ad6a47",
    "Fribidi": "d687fccf5f4a8b3ce2893cf04a51ef634670690c4ead668e68a0b6b786c81bae",
    "Harfbuzz": "886c75aa0090d439bf20f5930c185e5f1512ad18336826555c9b809fcdc09843",
    "Mbedcrypto": "cb2de5d405e67b03abbe92e69815895cbb4f6667af311d38e53935f93f51611d",
    "Mbedtls": "fae6db53703cac923177038434edb44240e445ad88b79355d058fd7a1caa5836",
    "Mbedx509": "91d69c96cf22cbaad97aabaab0fe30d4f8be7d6a1450def956f5ffb076725399",
    "Mpv": "41dd6132fb9e43116f1816d8ea81e2a242b1c33c4924d6aec2da3d9c04b780e7",
    "Png16": "60c60baa1e1fd5144792c78dcfbd39b517c8bf779101647d03cfc261ad214931",
    "Swresample": "1096192540897f7d183748f26dd453c60c478fc1cd07839087a0ceb680831622",
    "Swscale": "1255a6d6a26bdd7c3b3ab92e76865d20f545638f98dbdb8b069f6a3413fbcf3e",
    "Uchardet": "d86079576b5be7a2e405512293b0dcf068242295b26c37cc3510b845dfddf255",
    "Xml2": "cf1960d9d43f8c085c77bf1e502e5555036290cd9ec7f4001c7ec0cb64f207f2"
]
let libmpvProductTargets: [String] = ["media_kit_libs_macos_video"] + libmpvTargets

let package = Package(
    name: "media_kit_libs_macos_video",
    platforms: [
        .macOS("10.9")
    ],
    products: [
        .library(name: "media-kit-libs-macos-video", targets: libmpvProductTargets),
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
            name: "media_kit_libs_macos_video",
            dependencies: libmpvTargets.map { framework in .target(name: framework) },
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
