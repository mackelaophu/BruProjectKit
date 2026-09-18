//
//  AppLottieView.swift
//  UICore
//

import SwiftUI
import Lottie
public struct AppLottieView: View {
    public var name: String
    public var bundle: Bundle
    public var loopMode: LottieLoopMode
    
    public init(name: String,
                loopMode: LottieLoopMode = .playOnce) {
        self.name = name
        self.bundle = Bundle.module
        self.loopMode = loopMode
    }
    
    public var body: some View {
        if let cleanAnimation = loadCleanLottieAnimation() {
            LottieView(animation: cleanAnimation)
                .playing(loopMode: loopMode)
                .resizable()
        } else {
            Color.clear
        }
    }
    
    /// Hàm xóa chính xác phần tử watermark đè ở layer ngoài cùng
    private func loadCleanLottieAnimation() -> LottieAnimation? {
        guard let url = bundle.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        // 1. Parse JSON gốc
        guard var jsonDict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
              var layers = jsonDict["layers"] as? [[String: Any]],
              !layers.isEmpty else {
            return try? LottieAnimation.from(data: data)
        }
        
        // 2. Kiểm tra xem phần tử đầu tiên (layers[0]) có phải là Group Layer chứa watermark không
        // Thường Lottielab đặt tên layer watermark này là "Group Layer ..." hoặc chứa nhiều shape text.
        // Chúng ta sẽ xóa phần tử ĐẦU TIÊN (index 0) của mảng layers gốc.
        layers.removeFirst()
        
        // Cập nhật lại mảng layers đã sạch vào JSON
        jsonDict["layers"] = layers
        
        // 3. Convert ngược về Data và khởi tạo
        guard let cleanedData = try? JSONSerialization.data(withJSONObject: jsonDict, options: []),
              let animation = try? LottieAnimation.from(data: cleanedData) else {
            return try? LottieAnimation.from(data: data)
        }
        
        return animation
    }
}

#Preview {
    AppLottieView(name: "animation", loopMode: .loop)
}
