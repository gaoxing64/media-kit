# media-kit 测试案例库（面向 AI）

> 锚点：`feat/volume-normalize-libs 23ec6b9c`（2026-10-21）｜测试位于 `media_kit/test` 与 `media_kit_test`
> 五件套：[workflow-diagram.md](./workflow-diagram.md)｜[architecture.md](./architecture.md)｜[update-history.md](./update-history.md)｜[backlog.md](./backlog.md)
> 消费方：[simple_live_app](../../simple_live_app/doc/architecture.md)

## 1. 怎么跑

```bash
# Dart 单元/播放器测试（需系统 libmpv 或 LIBMPV_LIBRARY_PATH）
cd media-kit/media_kit && dart pub get && dart test
# Flutter 集成示例
cd media-kit/media_kit_test && flutter pub get && flutter test
```

CI：`.github/workflows/ci.yml`（Windows/Linux/macOS/Web + 示例构建）。

## 2. 现有测试资产

| 文件 | 覆盖 |
| --- | --- |
| `media_kit/test/src/player/player_test.dart` | Player 基本 API |
| `media_kit/test/src/player/native/core/native_library_test.dart` | 原生库定位/加载 |
| `media_kit/test/src/player/native/core/initializer_test.dart` | 初始化 |
| `media_kit/test/src/player/native/utils/asset_loader_test.dart` | 资源加载 |
| `media_kit/test/src/models/media/media_test.dart` | Media 模型 |
| `media_kit/test/src/models/media/player_state_test.dart` | 状态 |

## 3. AI 用例库

| ID | 前置 | 步骤 | 期望 |
| --- | --- | --- | --- |
| TC-M-01 | libmpv 可加载 | `NativeLibrary.ensureInitialized()` | 不抛异常，`path` 指向有效库 |
| TC-M-02 | Player 就绪 | `open(Media(url))` | `stream.error` 无错误；position 递增 |
| TC-M-03 | 播放中 | `pause()` → `play()` | 状态与音频同步切换 |
| TC-M-04 | 播放中 | `seek(10s)` | position 跳到 10s 附近 |
| TC-M-05 | 播放中 | `setRate(2.0)` | 播放速度约为 2x |
| TC-M-06 | 多音轨 | `setAudioTrack(i)` | 切轨成功、无崩溃 |
| TC-M-07 | 字幕 | `setSubtitleTrack(i)` | 字幕出现/切换 |
| TC-M-08 | 音量 | `setVolume(v)` | 属性值回读一致 |
| TC-M-09 | 多实例 | 同时创建 2 个 Player 播不同流 | 互不影响；各自释放正常 |
| TC-M-10 | 释放 | `dispose()` 后再操作 | 抛已释放错误或安全 no-op，不崩溃 |
| TC-M-11 | 坏地址 | `open(Media('http://invalid'))` | 进入 error 流，不卡死 |
| TC-M-12 | 视频 | `VideoController` + `Video` | 有画面、无黑屏；窗口尺寸变化正常 |
| TC-M-13 | 滤镜 | 设置 `af=lavfi=[loudnorm=...]` | 属性设置成功且有声（需二进制含滤镜） |
| TC-M-14 | 平台二进制 | 解包 libs 产物 `strings` | 含 `loudnorm/aresample`，Android jar 含 helper |

## 4. 写新测试约定

- 用例放 `media_kit/test/src/...`，文件名 `*_test.dart`。
- 联网源集中在 `test/common/sources*.dart`，离线优先。
- 释放/多实例用例必须显式 `dispose`，避免污染后续用例。

## 5. 已知缺口

- `media_kit_video` 无自动化测试，渲染只能真机冒烟。
- CI Windows 用的 libmpv 版本过期（backlog P0-1），测试结果不代表本项目二进制。

## 历史锚点

| 用例 | 守护的提交 |
| --- | --- |
| TC-M-13/14 滤镜/二进制 | `57ea33e5`、`d06a8d9f`、`23ec6b9c` |
