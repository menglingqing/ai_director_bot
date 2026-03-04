#!/bin/bash
# ai_director_bot - 上传到 GitHub 的脚本
# 用法：在项目根目录执行 ./scripts/push-to-github.sh
# 或：bash scripts/push-to-github.sh

set -e
cd "$(dirname "$0")/.."

echo "==> 检查 Git 状态..."
if [ ! -d .git ]; then
  echo "==> 初始化 Git 仓库..."
  git init
  git add .
  git commit -m "chore: init ai_director_bot project structure and workflow"
  echo "==> 已完成首次提交。"
else
  if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "chore: update ai_director_bot" || true
  fi
  echo "==> 已有 Git 仓库，跳过初始化。"
fi

echo ""
echo "请选择一种方式推送到 GitHub："
echo ""
echo "【方式一】已安装 GitHub CLI (gh)："
echo "  gh repo create ai_director_bot --public --source=. --remote=origin --push"
echo ""
echo "【方式二】手动创建仓库后推送："
echo "  1. 在 https://github.com/new 创建新仓库，名称填: ai_director_bot"
echo "  2. 不要勾选「Add a README」"
echo "  3. 在本地执行："
echo "     git remote add origin https://github.com/你的用户名/ai_director_bot.git"
echo "     git branch -M main"
echo "     git push -u origin main"
echo ""

if command -v gh &>/dev/null; then
  read -p "是否现在用 gh 创建并推送? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    gh repo create ai_director_bot --public --source=. --remote=origin --push
    echo "==> 已完成推送。"
  fi
fi
