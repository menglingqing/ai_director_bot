# S2：分镜概念的提示词生成

**阶段**：分镜概念与视觉设定  
**状态**：✅ 已有

## 输入

- 剧本/分镜表 + 单镜描述；可选：角色卡、场景设定（来自 s2-character、s2-scene）

## 输出

- 用于生成「分镜概念图」的 AI 绘图提示词（可按镜输出）

## 在流水线中的位置

- 在 S2 角色卡与场景设定之后，产出 `storyboard_concept_images`，供 S3 服化道使用。

## 可复用资源

- cinematic-prompt、magazine-interior-photo、canvas-design（见技能清单）
