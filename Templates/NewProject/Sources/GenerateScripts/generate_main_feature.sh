#!/bin/bash

# Script này dùng để tạo ra cấu trúc file cơ bản cho 1 module/feature mới nằm trong MAIN APP.
# Các file code sẽ được đặt trong AdapfitV2/Sources/<MODULE_NAME>.
# Nó cũng hỗ trợ BỔ SUNG file cho các module đã tồn tại (không ghi đè file cũ).
#
# Cách sử dụng:
# bash generate_main_feature.sh Dashboard

MODULE_NAME=$1

if [ -z "$MODULE_NAME" ]; then
    echo "❌ Vui lòng cung cấp tên feature bạn muốn tạo trong main app!"
    echo "👉 Ví dụ: ./generate_main_feature.sh Dashboard"
    exit 1
fi

echo "🚀 Đang xử lý template cho main app feature '$MODULE_NAME'..."

TMP_DIR=".tmp_scaffold"

# Xóa thư mục tạm nếu có từ lần chạy trước
rm -rf "$TMP_DIR"

# 1. Chạy lệnh tuist scaffold ra một thư mục tạm để không bị báo lỗi "File already exists"
# Dùng template Module để tạo ra đầy đủ các file (DI, View, ViewModel, Router, v.v...)
tuist scaffold Module --name "$MODULE_NAME" --path "$TMP_DIR" > /dev/null

if [ $? -eq 0 ]; then
    # 2. Tạo thư mục đích trong main app
    TARGET_SOURCES_DIR="AdapfitV2/Sources/$MODULE_NAME"
    mkdir -p "$TARGET_SOURCES_DIR"

    # 3. Dùng rsync copy từ thư mục tạm sang thư mục thật (chỉ lấy phần Sources)
    # -a: copy thư mục đệ quy giữ nguyên quyền
    # --ignore-existing: BỎ QUA các file đã tồn tại ở đích (KHÔNG GHI ĐÈ)
    rsync -a --ignore-existing "$TMP_DIR/Targets/$MODULE_NAME/Sources/" "$TARGET_SOURCES_DIR/"
    
    echo "✅ Xong! Feature '$MODULE_NAME' đã được thêm vào Main App."
    echo "   (Các file được đặt tại $TARGET_SOURCES_DIR)"
else
    echo "❌ Có lỗi xảy ra trong quá trình tạo template."
fi

# 4. Dọn dẹp thư mục tạm
rm -rf "$TMP_DIR"
