#!/bin/bash

# Script này dùng để tạo ra cấu trúc file cơ bản cho 1 module mới bằng Tuist Template.
# Nó cũng hỗ trợ BỔ SUNG file cho các module đã tồn tại (không ghi đè file cũ).
#
# Cách sử dụng:
# bash generate_module.sh Chart

MODULE_NAME=$1

if [ -z "$MODULE_NAME" ]; then
    echo "❌ Vui lòng cung cấp tên module bạn muốn tạo hoặc cập nhật!"
    echo "👉 Ví dụ: bash generate_module.sh Profile"
    exit 1
fi

echo "🚀 Đang xử lý template cho module '$MODULE_NAME'..."

TMP_DIR=".tmp_scaffold"

# Xóa thư mục tạm nếu có từ lần chạy trước
rm -rf "$TMP_DIR"

# 1. Chạy lệnh tuist scaffold ra một thư mục tạm để không bị báo lỗi "File already exists"
tuist scaffold Module --name "$MODULE_NAME" --path "$TMP_DIR" > /dev/null

if [ $? -eq 0 ]; then
    # 2. Tạo thư mục đích nếu chưa có để rsync có thể chép vào
    mkdir -p "Targets/"

    # 3. Dùng rsync copy từ thư mục tạm sang thư mục thật
    # -a: copy thư mục đệ quy giữ nguyên quyền
    # --ignore-existing: BỎ QUA các file đã tồn tại ở đích (KHÔNG GHI ĐÈ)
    rsync -a --ignore-existing "$TMP_DIR/Targets/" "Targets/"
    
    echo "✅ Xong! Module '$MODULE_NAME' đã được cập nhật."
    echo "   (Các file cũ được giữ nguyên, chỉ bổ sung các file còn thiếu từ template)"
    echo "💡 Nhắc nhở: Hãy kiểm tra file Project.swift xem đã khai báo target này chưa nhé!"
else
    echo "❌ Có lỗi xảy ra trong quá trình tạo template."
fi

# 4. Dọn dẹp thư mục tạm
rm -rf "$TMP_DIR"
