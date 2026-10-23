# media-kit 修改历史（Git 复现）

> 锚点：`feat/volume-normalize-libs 23ec6b9c`（2026-10-21）｜全仓 **2063** 条；本地分叉 **8** 条
> 五件套：[workflow-diagram.md](./workflow-diagram.md)｜[architecture.md](./architecture.md)｜[backlog.md](./backlog.md)｜[test-suite.md](./test-suite.md)
> 消费方：[simple_live_app](../../simple_live_app/doc/update-history.md)

> 作者列：G = gaoxing64，P = Predidit，其余为原值。

## 1. 复现命令

```bash
git log --date=short --pretty=format:'%h %ad %an %s'
git log --date=short --pretty=format:'%h %ad %an %s' upstream/main..HEAD
git log --since=2026-01-01 --date=short --pretty=format:'%h %ad %s'
git diff --stat upstream/main...HEAD
```

## 2. 本地分叉（相对 upstream/main 全量 8 条）

| 日期 | 提交 | 作者 | 内容 |
| --- | --- | --- | --- |
| 2026-09-28 | `23ec6b9c` | G | fix(libs): 修正 android x86_64 jar 的 SHA（此前一位抄错） |
| 2026-09-28 | `d06a8d9f` | G | feat(libs): bump libmpv to LuaJIT/Lua 5.2 enabled builds |
| 2026-09-28 | `0c631ed9` | G | fix(android): 补齐 libmediakitandroidhelper.so 并更新 jar 哈希 |
| 2026-09-27 | `57ea33e5` | G | feat(libs): bump libmpv to aresample-enabled builds |
| 2026-09-27 | `a33cbb69` | G | chore(windows): point libmpv at build with alimiter/acompressor |
| 2026-09-27 | `4db75cb0` | G | chore(android): point libmpv jars at builds with alimiter/acompressor |
| 2026-09-26 | `38e1106d` | G | chore(windows): switch libmpv to fork build with audio filters |
| 2026-09-26 | `c3c6afc4` | G | chore(android): switch libmpv jars to fork build with audio filters |

> 结论：fork 的 Dart 代码零改动；8 条全部落在 libs——下载 URL/SHA 与两处构建脚本（Android `build.gradle`、Windows `CMakeLists.txt`），指向自建 libmpv（滤镜/Lua/helper）。

## 3. 2026 年提交（41 条，全量）

| 日期 | 提交 | 作者 | 内容 |
| --- | --- | --- | --- |
| 2026-09-28 | `23ec6b9c` | G | fix(libs): 修正 android x86_64 jar 的 SHA（此前一位抄错） |
| 2026-09-28 | `d06a8d9f` | G | feat(libs): bump libmpv to LuaJIT/Lua 5.2 enabled builds |
| 2026-09-28 | `0c631ed9` | G | fix(android): 补齐 libmediakitandroidhelper.so 并更新 jar 哈希 |
| 2026-09-27 | `57ea33e5` | G | feat(libs): bump libmpv to aresample-enabled builds |
| 2026-09-27 | `a33cbb69` | G | chore(windows): point libmpv at build with alimiter/acompressor |
| 2026-09-27 | `4db75cb0` | G | chore(android): point libmpv jars at builds with alimiter/acompressor |
| 2026-09-26 | `38e1106d` | G | chore(windows): switch libmpv to fork build with audio filters |
| 2026-09-26 | `c3c6afc4` | G | chore(android): switch libmpv jars to fork build with audio filters |
| 2026-09-15 | `78d4cce7` | P | chore(windows): update libmpv video binaries to 202609151348 |
| 2026-09-15 | `4e1aafe0` | P | chore(windows): upgrade libmpv video binaries to 20260915 |
| 2026-08-11 | `994465d9` | P | build(deps): upgrade native video libraries |
| 2026-08-11 | `99c7358b` | ErBW_s | feat(ohos): improve hardware decode performance (#40) |
| 2026-08-04 | `6d744e4a` | P | chore(linux): upgrade libmpv binaries to 20260804 |
| 2026-07-31 | `e3d51713` | P | chore(linux): upgrade libmpv binaries to 20260730 |
| 2026-07-28 | `8241881c` | P | chore(linux): upgrade libmpv binaries to 20260728 |
| 2026-07-22 | `b11ec805` | P | fix: suppress osc noise (#38) |
| 2026-07-19 | `df5a969e` | P | feat: x11 H/W (#37) |
| 2026-07-02 | `652cfc76` | ErBW_s | feat: hardware decode for ohos (#35) |
| 2026-06-24 | `11d02cb8` | NihilDigit | feat: support windows arm64 libmpv (#34) |
| 2026-06-18 | `87cdfef7` | P | feat(video): add Android SurfaceTexture fallback option |
| 2026-06-14 | `11f72195` | P | feat: video bitrate (#33) |
| 2026-06-04 | `a7d4a070` | P | feat: safe screenshoot (#32) |
| 2026-06-04 | `665b55ca` | P | deps: bump android binary |
| 2026-05-23 | `13b332ad` | 0chencc | feat(darwin): add Swift Package Manager support pointing at Predidit/libmpv-darwin-build 0.6.7 (#31) |
| 2026-05-01 | `21aacaf9` | P | feat(win32): no stall pipeline (#29) |
| 2026-04-30 | `d19286c1` | P | refactor(win32): mailbox triple buffering (#28) |
| 2026-04-27 | `604d0a95` | P | deps: bump android binary |
| 2026-03-25 | `f228407d` | P | deps: bump darwin binary |
| 2026-02-26 | `4cd7c295` | P | fix(android): fix gles shader compile error (#27) |
| 2026-02-24 | `204b5c7c` | P | deps: bump android binary |
| 2026-02-16 | `afb5a1b1` | ErBW_s | feat: update ohos libmpv to support ad blocker (#26) |
| 2026-02-12 | `190b4ce2` | P | feat: shrink web assets |
| 2026-02-09 | `7d1e3f81` | ErBW_s | feat: add ohos support (#2) (#25) |
| 2026-02-08 | `d1ac737b` | P | fix(linux): only epoxy (#24) |
| 2026-02-07 | `88719753` | P | deps: bump android binary |
| 2026-01-31 | `b08e0744` | P | fix(android): API26 support (#23) |
| 2026-01-29 | `c04ddeea` | P | feat: add libplacebo shaderc patch for vulkan 1.4 (#22) |
| 2026-01-28 | `e3732e30` | P | fix: make gpu-next vo work on vulkan 1.1-only devices |
| 2026-01-28 | `90ea5598` | P | feat: mpv 0.41 (#21) |
| 2026-01-24 | `5bd14c6d` | P | deps: bump linux binary |
| 2026-01-24 | `b90a0c54` | P | deps: bump linux binary |

## 4. 年度分布与里程碑（含本地分叉）

| 年度 | 提交数 | 主题 |
| --- | --- | --- |
| 2026 | 41 | Windows ARM64、OHOS 硬解、Linux X11 硬解、SurfaceTexture 回退、16KB page |
| 2025 | 52 | media_kit 1.1.x / video 1.2.x；多平台纹理与控件 |
| 2024 | 262 | 播放器稳定性、Android/iOS 修复 |
| 2023 | 1459 | FFI 绑定、libs 包体系、Web 播放、video_player 适配 |
| 2022 及更早 | 249 | 项目初始与早期迭代 |

> 全量 2063 条用 §1 第一条命令导出；上游内部提交未逐条展开。

## 5. 当前状态

- 分支 `feat/volume-normalize-libs`，HEAD `23ec6b9c`；相对 `upstream/main` 领先 8 条。
- App 固定引用该 commit（`simple_live_app/pubspec.yaml:135-149`）。
