# S3：依靠分镜概念图定服化道的提示词生成

**阶段**：服化道与美术定稿  
**状态**：✅ 已有

## 输入

- 分镜概念图 + 镜号/场次（来自 S2）

## 输出

- 服装、化妆、道具、陈设等细化描述的提示词，可生成服化道参考图

## 在流水线中的位置

- 在 S2 分镜概念图之后，产出 `costume_reference_images`，供 s3-refine 垫图完善分镜图。

## 可复用资源

- oiran-photoshoot-prompt、nano-banana-interior 等（见技能清单）
