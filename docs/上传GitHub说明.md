# 上传到 GitHub 说明

按下面任选一种方式，把 **ai_director_bot** 推送到 GitHub。

---

## 一、先确保本地已有首次提交

在项目根目录 `ai_director_bot` 下执行：

```bash
cd /Users/menglingqing/Desktop/AIGC/ai_director_bot

# 若尚未初始化 Git
git init
git add .
git commit -m "chore: init ai_director_bot project structure and workflow"
```

---

## 二、推送到 GitHub

### 方式 A：使用 GitHub CLI（推荐）

若已安装 [GitHub CLI](https://cli.github.com/)（`gh`），在项目根目录执行：

```bash
gh repo create ai_director_bot --public --source=. --remote=origin --push
```

会在你的账号下创建公开仓库 `ai_director_bot` 并完成首次推送。

---

### 方式 B：在网页创建仓库后推送

1. 打开 [GitHub 新建仓库](https://github.com/new)。
2. **Repository name** 填：`ai_director_bot`。
3. 选择 **Public**，不要勾选 “Add a README file”。
4. 点击 **Create repository**。
5. 在本地项目根目录执行（把 `你的用户名` 换成你的 GitHub 用户名）：

```bash
cd /Users/menglingqing/Desktop/AIGC/ai_director_bot

git remote add origin https://github.com/你的用户名/ai_director_bot.git
git branch -M main
git push -u origin main
```

若使用 SSH：

```bash
git remote add origin git@github.com:你的用户名/ai_director_bot.git
git branch -M main
git push -u origin main
```

---

## 三、使用脚本（可选）

在项目根目录执行：

```bash
chmod +x scripts/push-to-github.sh
./scripts/push-to-github.sh
```

脚本会检查并完成首次提交，并提示你用 `gh` 或手动命令推送。

---

推送完成后，仓库地址一般为：  
`https://github.com/你的用户名/ai_director_bot`
