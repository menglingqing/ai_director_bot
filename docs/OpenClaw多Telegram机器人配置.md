# OpenClaw 连接多个 Telegram 机器人、按会话区分交互

你已有一个 Telegram 机器人接在 OpenClaw 上，现在要再接入一个（例如导演助手 @mlqDirectorbot）。做法是：在同一个 Gateway 下配置 **Telegram 多账号（accounts）**，再用 **bindings** 把不同机器人路由到不同 **Agent**，这样每个机器人对应独立的工作区、记忆和人格，会话自然分开。

---

## 一、思路概览

- **一个 Gateway**：`openclaw gateway` 同时跑多个 Telegram Bot（多个 token）。
- **Telegram 多账号**：在 `channels.telegram.accounts` 里为每个 Bot 起一个账号名（如 `main`、`director`），每个账号填自己的 `botToken`。
- **多 Agent**：在 `agents.list` 里为每个“角色”建一个 Agent（如通用助手、导演助手），各自有 `workspace`、可配不同 `model` / 技能 / system prompt。
- **路由绑定**：用 `bindings` 把「哪个 channel + 哪个 account」交给「哪个 agent」，这样和机器人 A 的对话只会进 Agent A，和机器人 B 的对话只进 Agent B，会话互不串。

---

## 二、配置 `~/.openclaw/openclaw.json`（或你实际使用的配置文件）

下面用两个 Bot 举例：  
- 第一个：你原来已连接的（这里叫 `main`，用默认 token）。  
- 第二个：导演助手（这里叫 `director`，用新 Bot 的 token）。

**1. Telegram 多账号（两个 Bot、两个 token）**

在 `channels.telegram` 里不要只写一个 `botToken`，而是用 `accounts` 区分两个 Bot，并设好默认账号：

```json5
{
  channels: {
    telegram: {
      enabled: true,
      dmPolicy: "pairing",
      groups: { "*": { requireMention: true } },

      // 第一个 Bot：原有机器人，作为 default 账号
      defaultAccount: "main",
      accounts: {
        main: {
          botToken: "第一个机器人的Token",
          // 若你之前用环境变量 TELEGRAM_BOT_TOKEN，可继续用，这里写进 config 更清晰
        },
        director: {
          botToken: "第二个机器人的Token（导演助手 @mlqDirectorbot）",
        },
      },
    },
  },
}
```

说明：

- 有两个或以上账号时，建议显式写 `defaultAccount`（例如 `"main"`），避免歧义。
- 每个账号的私聊/群策略若不同，可在对应 `accounts.<name>` 下再写 `dmPolicy`、`allowFrom`、`groups` 等。

**2. 定义两个 Agent（两个“大脑”）**

在 `agents.list` 里给两个机器人各配一个 Agent，workspace 分开，便于隔离文件与记忆：

```json5
{
  agents: {
    list: [
      {
        id: "main",
        default: true,
        name: "通用助手",
        workspace: "~/.openclaw/workspace-main",
        model: "anthropic/claude-sonnet-4-5",
        // 原有技能、identity 等
      },
      {
        id: "director",
        name: "导演助手",
        workspace: "~/.openclaw/workspace-director",
        model: "anthropic/claude-sonnet-4-5",
        // 可在此 agent 的 workspace 里放 AGENTS.md、SOUL.md 或技能，用导演助手逻辑
      },
    ],
  },
}
```

导演助手的 system prompt / 行为可放在 `~/.openclaw/workspace-director` 下的 `AGENTS.md`、`SOUL.md` 或技能里；也可通过你对接 OpenClaw 的方式注入（例如 Telegram Bot 的“描述/指令”由 OpenClaw 读入）。

**3. 用 bindings 把“哪个 Telegram 账号 → 哪个 Agent”绑死**

这样不同机器人进不同会话、不同 Agent：

```json5
{
  bindings: [
    { agentId: "director", match: { channel: "telegram", accountId: "director" } },
    { agentId: "main",     match: { channel: "telegram", accountId: "main" } },
  ],
}
```

路由规则：**更具体的 match 优先**。上面两条已经按 channel + accountId 区分，两个 Bot 会分别只进 `director` 和 `main`。  
若有其他 channel（如 WhatsApp），可继续加，例如：

```json5
{ agentId: "main", match: { channel: "whatsapp" } },
```

**4. 拼成一份完整示例（只保留相关片段）**

```json5
{
  channels: {
    telegram: {
      enabled: true,
      dmPolicy: "pairing",
      groups: { "*": { requireMention: true } },
      defaultAccount: "main",
      accounts: {
        main:     { botToken: "第一个Bot的Token" },
        director: { botToken: "第二个Bot的Token（导演助手）" },
      },
    },
  },
  agents: {
    list: [
      { id: "main", default: true, name: "通用助手", workspace: "~/.openclaw/workspace-main", model: "anthropic/claude-sonnet-4-5" },
      { id: "director", name: "导演助手", workspace: "~/.openclaw/workspace-director", model: "anthropic/claude-sonnet-4-5" },
    ],
  },
  bindings: [
    { agentId: "director", match: { channel: "telegram", accountId: "director" } },
    { agentId: "main",     match: { channel: "telegram", accountId: "main" } },
  ],
}
```

Token 不要提交到 Git；可放在环境变量或本机仅自己可读的 config 里。

---

## 三、会话如何“按不同机器人”分开

- **Telegram 侧**：用户和 Bot A 的对话、和 Bot B 的对话，本身就是不同 chat；Gateway 按收到的 `bot token` 识别是哪个 account。
- **OpenClaw 侧**：通过 `bindings` 的 `channel + accountId` 把该 account 的请求全部交给对应 agent；每个 agent 有独立 workspace 和会话状态，所以：
  - 和第一个机器人的对话 → 只进 `main` agent，会话只在 main 的上下文中；
  - 和第二个机器人（导演助手）的对话 → 只进 `director` agent，会话只在 director 的上下文中。
- 因此“通过不同会话交互” = 用不同 Telegram 机器人即可；无需额外会话 ID，只要两个 Bot 的 token 配在两个 account 下并绑到两个 agent 即可。

---

## 四、操作步骤小结

1. 在 `~/.openclaw/openclaw.json` 里：
   - 在 `channels.telegram.accounts` 里加第二个账号（如 `director`），填导演助手 Bot 的 token；
   - 原有 Bot 放到 `accounts.main`（或保留顶层 `botToken` 并设 `defaultAccount: "main"`，以文档为准）；
   - 设好 `defaultAccount`。
2. 在 `agents.list` 里增加导演助手用的 agent（如 `id: "director"`），`workspace` 指向单独目录。
3. 在 `bindings` 里增加两条：`telegram` + `accountId: "main"` → `main`，`telegram` + `accountId: "director"` → `director`。
4. 重启 Gateway：`openclaw gateway`。
5. 新 Bot 首次私聊时，若用 pairing，执行：`openclaw pairing list telegram`，再 `openclaw pairing approve telegram <CODE>`（code 针对该 account 的会话）。

之后：和第一个机器人聊 → 通用助手；和第二个机器人（@mlqDirectorbot）聊 → 导演助手，两边的会话和记忆互不干扰。

---

## 五、参考

- OpenClaw 官方：Telegram 多账号与 routing  
  - [Telegram](https://docs.openclaw.ai/channels/telegram)（`accounts`、`defaultAccount`）  
  - [Multi-agent](https://open-claw.bot/docs/concepts/multi-agent/)（多 Agent + bindings）  
- 本仓库导演助手行为与 system prompt：`config/telegram-bot-system-prompt.md`（可放到 director 的 workspace 或通过你的 Bot 配置注入）。
