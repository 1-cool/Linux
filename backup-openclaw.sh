#!/bin/bash
# OpenClaw 数据备份脚本
# 备份 memory/、workspace/、skills/ 文件夹和 openclaw.json 文件
# 打包成 7z 格式，存放于 /mnt/backup/

# 配置
OPENCLAW_DIR="$HOME/.openclaw"
BACKUP_DIR="/mnt/backup"
DATE=$(date +%Y%m%d)
BACKUP_FILE="${BACKUP_DIR}/openclaw-${DATE}.7z"

# 要备份的内容
BACKUP_ITEMS=(
    "${OPENCLAW_DIR}/memory"
    "${OPENCLAW_DIR}/workspace"
    "${OPENCLAW_DIR}/skills"
    "${OPENCLAW_DIR}/openclaw.json"
)

# 检查备份目录是否存在
if [ ! -d "$BACKUP_DIR" ]; then
    echo "创建备份目录: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# 检查源目录是否存在
if [ ! -d "$OPENCLAW_DIR" ]; then
    echo "错误: OpenClaw 目录不存在: $OPENCLAW_DIR"
    exit 1
fi

# 检查 7z 是否安装
if ! command -v 7z &> /dev/null; then
    echo "错误: 7z 未安装，请先安装 p7zip-full"
    exit 1
fi

# 执行备份
echo "开始备份 OpenClaw 数据..."
echo "备份内容:"
for item in "${BACKUP_ITEMS[@]}"; do
    if [ -e "$item" ]; then
        echo "  ✓ $item"
    else
        echo "  ✗ $item (不存在，跳过)"
    fi
done

# 使用 7z 压缩
7z a -t7z -mx=5 "$BACKUP_FILE" "${BACKUP_ITEMS[@]}" 2>/dev/null

# 检查备份是否成功
if [ $? -eq 0 ] && [ -f "$BACKUP_FILE" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo ""
    echo "备份完成!"
    echo "  文件: $BACKUP_FILE"
    echo "  大小: $BACKUP_SIZE"
else
    echo "错误: 备份失败"
    exit 1
fi

# 显示备份目录中的文件列表
echo ""
echo "备份目录中的文件:"
ls -lh "$BACKUP_DIR"/openclaw-*.7z 2>/dev/null | tail -5
