# media-kit 工作流程图

> 锚点：`feat/volume-normalize-libs 23ec6b9c`（2026-10-21）｜范围：Dart FFI 播放器、video 渲染、libs 二进制、CI
> 五件套：[architecture.md](./architecture.md)｜[update-history.md](./update-history.md)｜[backlog.md](./backlog.md)｜[test-suite.md](./test-suite.md)
> 上游消费方：[simple_live_app](../../simple_live_app/doc/architecture.md)｜二进制来源：[win32](../../libmpv-win32-video-cmake/doc/architecture.md)｜[android](../../libmpv-android-video-build/doc/architecture.md)｜[darwin](../../libmpv-darwin-build/doc/architecture.md)

## 1. 初始化链

```
App 启动
  → MediaKit.ensureInitialized()            # 注册 libs 包/平台
  → NativeLibrary.ensureInitialized()       # 定位并打开 libmpv
       Windows: libmpv-2.dll
       Linux:   libmpv.so / libmpv.so.2
       macOS/iOS/Android: 随包打包
  → DynamicLibrary.open(NativeLibrary.path)
  → generated.MPV(...)                      # ffigen 绑定
  → Player(configuration)                   # NativePlayer
```

证据：`media_kit/lib/src/player/native/core/native_library.dart:30-100`、`player/real.dart:43-77`。

## 2. 播放链

```
Player.open(Media(uri), play: true)
  → set property: loadfile / pause=no
  → libmpv 起播（network + demux + decode）
  → 属性事件 → Player.stream.{position,duration,buffering,error,...}
  → VideoController(video: controller) 挂接渲染
       Windows: DXGI render API（定制 libmpv）
       Android: SurfaceTexture/mediacodec
       macOS/iOS: Metal/OpenGL
       Linux: GL/X11
  → Video widget 显示纹理
```

## 3. 控制与状态

```
play/pause/seek/setRate/setVolume/setAudioTrack/setSubtitleTrack
  → mpv_set_property / command
  → 属性变化 → StreamController → UI
```

- `PlatformPlayer` 抽象：`media_kit/lib/src/player/platform_player.dart`。
- Web 走 HTML `<video>`，不是 libmpv：`player/web/player/real.dart`。

## 4. 释放链

```
Player.dispose() → 停事件订阅 → mpv terminate/destroy → 释放 native 引用
VideoController.dispose() → 解绑纹理/原生 surface
```

释放时序受上游 issue #1443 影响（见 [app backlog](../../simple_live_app/doc/backlog.md)）。

## 5. 二进制进入仓库的链

```
libmpv-{win32,android,darwin} 发布制品
  → 更新 libs/<platform>/media_kit_libs_*/ 的下载 URL/SHA
  → App 通过 dependency_overrides 固定到本 fork 的 commit（23ec6b9c）
  → 构建时下载/解包到平台工程
```

## 6. 失败与兜底

| 失败点 | 表现 | 兜底 |
| --- | --- | --- |
| 找不到 libmpv | `Cannot find libmpv-2.dll ...` | 报错提示 PATH/打包位置（`native_library.dart:80-95`） |
| Android 缺 helper | 硬解/输出失败、黑屏 | jar 必须含 `libmediakitandroidhelper.so`（见 android KB） |
| 纹理未挂接 | 有声音无画面 | 检查 `VideoController` 创建时机与平台实现 |
| 释放竞态 | 切台/退出崩溃 | 串行 dispose；关注上游 #1443 |

## 历史锚点

| 流程 | 关键提交 |
| --- | --- |
| Android 滤镜 libs | `c3c6afc4`、`4db75cb0`、`57ea33e5` |
| Windows 滤镜 libs | `38e1106d`、`a33cbb69` |
| Android helper | `0c631ed9` |
| LuaJIT/Lua libs | `d06a8d9f` |
| jar SHA 修正 | `23ec6b9c` |
