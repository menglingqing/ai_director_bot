# S4：分镜 ↔ 运镜提示词（联动）

**阶段**：运镜与节奏  
**状态**：🔗 与现有技能联动

## 输入

- 分镜表/单镜描述 + 叙事意图

## 输出

- 每镜对应的运镜提示词（景别、运镜方式、节奏），兼容 Seedance/即梦 等

## 在流水线中的位置

- S4 与 s4-beat 并列，产出 `camera_prompts`，供 S5 视频生成使用。

## 联动说明

- 复用现有 **seedance-camera-prompt**（如 AIGC 项目下 `.cursor/skills/seedance-camera-prompt`）。
- ai_director_bot 负责按镜调用该技能，并将分镜表/单镜描述与叙事意图传入。
