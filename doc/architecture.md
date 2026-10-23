# media-kit 架构与选型对照

> 锚点：`feat/volume-normalize-libs 23ec6b9c`（2026-10-21）｜范围：Dart 包、FFI、平台渲染、libs、
> 五件套：[workflow-diagram.md](./workflow-diagram.md)｜[update-history.md](./update-history.md)｜[backlog.md](./backlog.md)｜[test-suite.md](./test-suite.md)
> 消费方：[simple_live_app](../../simple_live_app/doc/architecture.md)｜二进制来源：[win32](../../libmpv-win32-video-cmake/doc/architecture.md)｜[android](../../libmpv-android-video-build/doc/architecture.md)｜[darwin](../../libmpv-darwin-build/doc/architecture.md)

## 1. 定位

跨平台 libmpv 的 Flutter 封装（melos 单仓）。本 fork 相对上游 `Predidit/media-kit` **只改二进制指向**：8 个提交全部落在 `libs/*`（下载 URL/SHA 与 Android `build.gradle`、Windows `CMakeLists.txt` 两处构建脚本），Dart 播放器代码与上游完全一致。

## 2. 仓库结构

| 包 | 版本 | 职责 |
| --- | --- | --- |
| `media_kit` | 1.1.11 | Player/Media/Playlist/Streams；FFI 绑定 libmpv |
| `media_kit_video` | 1.2.5 | VideoController/Video widget；各平台纹理渲染 |
| `video_player_media_kit` | — | video_player 接口适配 |
| `libs/android` | 1.3.6 | per-ABI jar（含 helper） |
| `libs/windows` | video 1.0.10 / audio 1.0.9 | libmpv-2.dll |
| `libs/ios`,`macos` | 1.1.4 | xcframework/dylib |
| `libs/linux` | 1.1.3 | libmpv.so |
| `libs/ohos` | 1.0.0 | HarmonyOS |
| `media_kit_test` | — | 集成示例/CI 构建目标 |

## 3. 分层与依赖

```
App → media_kit_video → media_kit → libmpv (FFI)
                     ↘ libs/<platform>（只提供二进制）
```

- `media_kit` 不依赖 Flutter（可用于纯 Dart）；`media_kit_video` 才是 Flutter 插件。
- 原生库加载：`native_library.dart:30-100`，按平台尝试多个候选名，支持 `LIBMPV_LIBRARY_PATH`。
- FFI 绑定由 ffigen 从 `headers/client.h` 生成：`lib/generated/libmpv/bindings.dart`。

## 4. 选型对照

| 选择 | 理由 | 代价 |
| --- | --- | --- |
| libmpv + FFI，而非 platform video_player | 统一四平台行为、支持直播/字幕/音轨/滤镜 | 需自建各平台 libmpv 二进制 |
| 单一 `Player` API + 平台 `PlatformPlayer` 实现 | Web 与 native 可替换 | 抽象层多一层 |
| 二进制放在独立 `libs_*` 包 | App 只依赖所需平台/音视频变体 | 版本与 SHA 需人工同步 |
| fork 只改 libs，不改播放器代码 | 降低与上游漂移 | 自研能力依赖上游合并 |

## 5. 本项目如何消费

- `simple_live_app/pubspec.yaml:135-149` 用 `dependency_overrides` 把 `media_kit_libs_{linux,ios_video,android_video}` 固定到本 fork 的 `23ec6b9c`。
- 播放器功能（音量均衡、后台播放）由 App 侧通过 libmpv 属性/滤镜实现，二进制必须含对应滤镜（见三个 libmpv KB）。

## 6. 风险

- 上游代码演进快，fork 仅 8 条 libs 提交，合并上游需重放二进制更新。
- `media_kit_video` 各平台纹理实现差异大，Windows 依赖定制 DXGI render API。
- CI 的 Windows 测试仍下载 **2023-08-11 上游 libmpv**，与本项目二进制不一致（backlog P0-1）。

## 历史锚点

| 决策 | 提交 |
| --- | --- |
| 二进制指向自建 libmpv（Android） | `c3c6afc4`、`4db75cb0`、`57ea33e5` |
| 二进制指向自建 libmpv（Windows） | `38e1106d`、`a33cbb69` |
| 补齐 Android helper | `0c631ed9` |
| Lua 构建 | `d06a8d9f` |
