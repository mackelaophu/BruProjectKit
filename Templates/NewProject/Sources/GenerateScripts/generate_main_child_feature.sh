#!/bin/bash

# Script này dùng để tạo ra cấu trúc file cơ bản cho 1 child feature nằm trong MAIN APP.
# Các file code sẽ được đặt trong AdapfitV2/Sources/<PARENT_FEATURE>/<MODULE_NAME>.
# Nó cũng hỗ trợ BỔ SUNG file (không ghi đè file cũ).
#
# Cách sử dụng:
# bash generate_main_child_feature.sh DashboardStats Dashboard

MODULE_NAME=$1
PARENT_FEATURE=$2

if [ -z "$MODULE_NAME" ] || [ -z "$PARENT_FEATURE" ]; then
    echo "❌ Vui lòng cung cấp tên child feature và parent feature!"
    echo "👉 Ví dụ: ./generate_main_child_feature.sh ProfileEdit Profile"
    exit 1
fi

echo "🚀 Đang xử lý template cho child feature '$MODULE_NAME' vào parent '$PARENT_FEATURE' trong main app..."

TMP_DIR=".tmp_scaffold"

# Xóa thư mục tạm nếu có từ lần chạy trước
rm -rf "$TMP_DIR"

# 1. Chạy lệnh tuist scaffold ra một thư mục tạm
# Dùng template ChildModule
tuist scaffold ChildModule --name "$MODULE_NAME" --parent-module "$PARENT_FEATURE" --path "$TMP_DIR" > /dev/null

if [ $? -eq 0 ]; then
    # 2. Tạo thư mục đích trong main app
    TARGET_DIR="AdapfitV2/Sources/$PARENT_FEATURE/$MODULE_NAME"
    mkdir -p "$TARGET_DIR"

    # 3. Dùng rsync copy từ thư mục tạm sang thư mục thật
    rsync -a --ignore-existing "$TMP_DIR/Targets/$MODULE_NAME/Sources/" "$TARGET_DIR/"
    
    echo "✅ Xong! Child feature '$MODULE_NAME' đã được thêm vào '$PARENT_FEATURE' trong Main App."
    echo "   (Các file được đặt tại $TARGET_DIR)"
else
    echo "❌ Có lỗi xảy ra trong quá trình tạo template."
fi

# 4. Dọn dẹp thư mục tạm
rm -rf "$TMP_DIR"
