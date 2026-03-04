# Telegram Bot 部署说明

## Bot 链接

- **对话入口**：部署完成后，在 OpenClaw 或 Telegram Bot 管理后台查看你的 Bot 链接（格式为 `https://t.me/你的Bot用户名`）。**请勿将真实 Bot 链接或 @ 用户名提交到公开仓库**，以免暴露隐私。

## Token 与安全

- Bot 的 **HTTP API Token** 由 @BotFather 颁发，相当于 Bot 的密码，**任何人拿到都可以控制你的 Bot**。
- **不要**把 Token 写进代码或提交到 Git 仓库。
- **不要**在公开场合（群聊、截图、文档）粘贴完整 Token。
- 若 Token 已泄露，请在 Telegram 找 @BotFather → 对应 Bot → **Revoke current token** 重新生成，并更新到你运行 Bot 的环境变量中。

## 本地 / 服务端配置

若你之后用自建服务（如 Python/Node 等）对接 Telegram Bot API，建议：

1. 在项目根目录创建 **`.env`**（已加入 `.gitignore`，不会被打包提交）：
   ```
   TELEGRAM_BOT_TOKEN=你的Token
   ```
2. 代码中从环境变量读取：`os.environ["TELEGRAM_BOT_TOKEN"]` 或 `process.env.TELEGRAM_BOT_TOKEN`。
3. 可保留 **`.env.example`** 作为模板（不写真实 Token），方便他人或自己在新环境配置：
   ```
   TELEGRAM_BOT_TOKEN=your_bot_token_here
   ```

## 在 OpenClaw 里同时接多个 Telegram 机器人

若你已经在用 OpenClaw 接了一个 Telegram Bot，现在要再接入导演助手（或更多 Bot），让不同机器人对应不同“大脑”和会话，请直接看：**[OpenClaw 多 Telegram 机器人配置](../docs/OpenClaw多Telegram机器人配置.md)**。核心是：在 `channels.telegram.accounts` 里配多个账号（每个一个 token），在 `bindings` 里用 `channel: "telegram"` + `accountId` 把每个 Bot 路由到不同 Agent。

---

## 后续可做

- 在 Bot 设置里添加 **description**、**about**、**profile picture**（见 @BotFather 的提示）。
- 若 Bot 稳定运行且需要更好记的用户名，可联系 [Bot Support](https://t.me/BotSupport) 申请更换用户名。
- System Prompt / 角色设定见：[telegram-bot-system-prompt.md](./telegram-bot-system-prompt.md)。
