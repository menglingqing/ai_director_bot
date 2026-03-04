# S4：音乐卡点/节奏同步提示词（联动）

**阶段**：运镜与节奏  
**状态**：🔗 与现有技能联动，可选

## 输入

- BGM 或节奏描述 + 分镜片段

## 输出

- 画面与节奏同步的提示词（如即梦 2.0 卡点）

## 在流水线中的位置

- S4 可选步骤，产出 `beat_sync_prompts`，与运镜一起供成片使用。

## 联动说明

- 复用现有 **music-beat-sync-prompt**（如 AIGC 项目下 `.cursor/skills/music-beat-sync-prompt`）。
- ai_director_bot 在用户需要 BGM 卡点时按需调用。
