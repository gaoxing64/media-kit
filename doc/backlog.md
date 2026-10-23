# media-kit 待办与优化清单

> 锚点：`feat/volume-normalize-libs 23ec6b9c`（2026-10-21）
> 五件套：[workflow-diagram.md](./workflow-diagram.md)｜[architecture.md](./architecture.md)｜[update-history.md](./update-history.md)｜[test-suite.md](./test-suite.md)
> 消费方：[simple_live_app](../../simple_live_app/doc/architecture.md)

## P0 — 会直接影响播放

| ID | 现象 | 证据 | 建议 |
| --- | --- | --- | --- |
| P0-1 | CI Windows 测试仍下载 2023-08-11 的上游 libmpv，与本项目实际二进制不同 | `.github/workflows/ci.yml:17-25` | 改为本项目 Release 产物并校验 SHA |
| P0-2 | libs 指向的二进制缺少 AF 滤镜时，App 音量均衡静默失效 | 本分支 8 条提交即为修此问题 | 发布流程加滤镜符号检查（见 test-suite） |
| P0-3 | Android jar 缺 helper 会黑屏无声 | `0c631ed9`；android KB P0-1 | 保持 jar 内容断言；升级时复验 |

## P1 — 平台脆弱点

| ID | 现象 | 证据 | 建议 |
| --- | --- | --- | --- |
| P1-1 | 播放器释放时序与上游 issue #1443 相关，切台/退出可能竞态 | 上游 issue；`player/real.dart` dispose | 串行释放；升级后回归多开 |
| P1-2 | 各平台纹理实现差异大，Windows 依赖定制 DXGI | `media_kit_video` 平台目录 | Windows 变更必须真机验证 |
| P1-3 | 只固定了 linux/ios_video/android_video 三个 libs，Windows/macOS 可能落到 pub 版本 | `simple_live_app/pubspec.yaml:135-149` | 核对并补齐 override |
| P1-4 | `libs/*` 版本号与二进制内容无强绑定 | 各 `libs/*/pubspec.yaml` | 每次换二进制 bump 版本并记 SHA |

## P2 — 结构 / 维护

| ID | 现象 | 证据 | 建议 |
| --- | --- | --- | --- |
| P2-1 | 与上游同步靠人工重放 8 条 libs 提交 | `upstream/main..HEAD` | 写同步脚本/清单 |
| P2-2 | `media_kit_test` 仅 2 个测试，覆盖有限 | `find media_kit_test` | 扩播放/释放/多实例用例 |
| P2-3 | `per-player-per-thread` 等分支未合并 | 远程分支列表 | 评估后合并或删除 |
| P2-4 | OHOS 包未纳入本项目验证 | `libs/ohos` | 明确不支持或补冒烟 |

## 已决策取舍

- 不在 fork 中改播放器代码：所有能力依赖上游，fork 只负责二进制。
- 保持 melos 单仓结构，不拆包。

## 历史锚点

| 条目 | 来源提交 |
| --- | --- |
| P0-2 滤镜缺失静默失效 | `57ea33e5`（aresample） |
| P0-3 Android 缺 helper 黑屏 | `0c631ed9` |
| P0-1 CI libmpv 版本过期 | 见 `.github/workflows/ci.yml`，未随 2026-09 libs 更新 |
