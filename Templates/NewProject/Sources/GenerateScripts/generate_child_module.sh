#!/bin/bash

# Script này dùng để tạo ra cấu trúc file cơ bản cho 1 module mới bằng Tuist Template.
# Nó cũng hỗ trợ BỔ SUNG file cho các module đã tồn tại (không ghi đè file cũ).
#
# Cách sử dụng:
# bash generate_module.sh Chart

MODULE_NAME=$1
PARENT_MODULE=$2

if [ -z "$MODULE_NAME" ] || [ -z "$PARENT_MODULE" ]; then
    echo "❌ Vui lòng cung cấp tên child module và parent module!"
    echo "👉 Ví dụ: ./generate_child_module.sh RegisterAccount Login"
    exit 1
fi

echo "🚀 Đang xử lý template cho child module '$MODULE_NAME' vào parent '$PARENT_MODULE'..."

TMP_DIR=".tmp_scaffold"

# Xóa thư mục tạm nếu có từ lần chạy trước
rm -rf "$TMP_DIR"

# 1. Chạy lệnh tuist scaffold ra một thư mục tạm để không bị báo lỗi "File already exists"
tuist scaffold ChildModule --name "$MODULE_NAME" --parent-module "$PARENT_MODULE" --path "$TMP_DIR" > /dev/null

if [ $? -eq 0 ]; then
    # 2. Tạo thư mục đích
    TARGET_DIR="Targets/$PARENT_MODULE/Sources/$MODULE_NAME"
    mkdir -p "$TARGET_DIR"

    # 3. Dùng rsync copy từ thư mục tạm sang thư mục thật
    rsync -a --ignore-existing "$TMP_DIR/Targets/$MODULE_NAME/Sources/" "$TARGET_DIR/"
    
    echo "✅ Xong! Child module '$MODULE_NAME' đã được thêm vào '$PARENT_MODULE'."
    echo "   (Các file được đặt tại $TARGET_DIR)"
else
    echo "❌ Có lỗi xảy ra trong quá trình tạo template."
fi

# 4. Dọn dẹp thư mục tạm
rm -rf "$TMP_DIR"
