# Hourly Work Logger

这是一个 `macOS` 后台系统弹窗记录器，外加一个本地网页控制台。

现在的结构是：

- 后台本体：`launchd` 每分钟运行一次检查脚本
- 真正弹窗：系统级 `osascript` 对话框
- 网页控制台：本地网页，只负责改参数、手动触发、查看历史记录

## 你要的效果

本体保留后台弹窗版。

网页页面不自己弹浏览器对话框，而是：

- 配置后台弹窗参数
- 手动触发一次系统弹窗
- 查看已经记录过的内容

## 主要文件

- [install.sh](/Users/ruirui/Documents/Codex/2026-05-02/mac-iphone/install.sh)：安装后台任务
- [serve.sh](/Users/ruirui/Documents/Codex/2026-05-02/mac-iphone/serve.sh)：启动网页控制台
- [logger_core.py](/Users/ruirui/Documents/Codex/2026-05-02/mac-iphone/logger_core.py)：后台核心逻辑
- [control_server.py](/Users/ruirui/Documents/Codex/2026-05-02/mac-iphone/control_server.py)：网页控制台后端
- [index.html](/Users/ruirui/Documents/Codex/2026-05-02/mac-iphone/index.html)：网页控制台页面

## 安装后台弹窗

执行：

```bash
zsh /Users/ruirui/Documents/Codex/2026-05-02/mac-iphone/install.sh
```

安装后会在当前用户下创建：

- `~/Library/LaunchAgents/com.codex.hourly-work-logger.plist`
- `~/Library/Application Support/HourlyWorkLogger/config.json`
- `~/Library/Application Support/HourlyWorkLogger/state.json`
- `~/Library/Application Support/HourlyWorkLogger/hourly-log.csv`

## 打开网页控制台

执行：

```bash
zsh /Users/ruirui/Documents/Codex/2026-05-02/mac-iphone/serve.sh
```

然后访问：

`http://127.0.0.1:4173`

## 网页控制台能做什么

- 启用或暂停后台提醒
- 设置“每小时第几分钟弹”或“每隔多少分钟弹”
- 设置工作开始和结束时间
- 修改系统弹窗标题和提示文案
- 手动立刻触发一次系统弹窗
- 查看历史记录

## 数据位置

后台配置和记录都保存在：

`~/Library/Application Support/HourlyWorkLogger`

其中最重要的是：

- `config.json`：网页里保存的参数
- `state.json`：后台最近一次触发状态
- `hourly-log.csv`：你输入过的记录

## 限制说明

- 这是 `macOS` 的系统弹窗方案，不是浏览器弹窗
- 它不能真正锁死整个系统，只能做到非常强的提醒
- `iPhone` 不能实现“必须填完才能继续使用整个系统”
