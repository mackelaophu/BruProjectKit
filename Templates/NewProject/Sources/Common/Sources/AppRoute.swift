//
//  AppRoute.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 31/5/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import Foundation
public enum AppRouteConstants {
    public static let paramsRoutePrefix = "params_route"
    public static let pathKey = "path"
    public static let functionKey = "function"
}

public func getRouteQueryParams(path: String, function: String, params: [String: String] = [:]) -> String {
    // 1. Khởi tạo chuỗi gốc với path và function
    let baseString = "\(AppRouteConstants.paramsRoutePrefix)?\(AppRouteConstants.pathKey)=\(path)&\(AppRouteConstants.functionKey)=\(function)"
    
    // 2. Nếu không có param nào thêm, trả về luôn
    guard !params.isEmpty else { return baseString }
    
    // 3. Dùng map/compactMap để biến Dictionary thành mảng ["key=value"], sau đó nối lại bằng "&"
    let extraParamsString = params.compactMap { key, value in
        let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
        let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
        return "\(encodedKey)=\(encodedValue)"
    }.joined(separator: "&")
    
    // 4. Nối chuỗi gốc và chuỗi param phụ
    return "\(baseString)&\(extraParamsString)"
}

// MARK: - Decode (đối xứng với getRouteQueryParams)

/// Kết quả parse một params-route. `path` và `function` luôn có mặt,
/// các tham số phụ (email, index, ...) nằm trong `params` đã được percent-decode sẵn.
public struct RouteComponents: Equatable {
    public let path: String
    public let function: String
    public let params: [String: String]

    public init(path: String, function: String, params: [String: String]) {
        self.path = path
        self.function = function
        self.params = params
    }

    /// Lấy 1 tham số phụ theo key. Trả về `nil` nếu không có.
    public func param(_ key: String) -> String? { params[key] }
}

/// Parse chuỗi rawValue dạng `params_route?path=...&function=...&key=value...`
/// thành ``RouteComponents``. Đây là chiều ngược của ``getRouteQueryParams(path:function:params:)``.
///
/// - Returns: `nil` nếu chuỗi không phải params-route hoặc thiếu `path`/`function`.
///   `URLComponents` tự percent-decode value nên không cần xử lý thủ công.
public func decodeRouteQueryParams(_ raw: String) -> RouteComponents? {
    guard raw.hasPrefix(AppRouteConstants.paramsRoutePrefix),
          let items = URLComponents(string: raw)?.queryItems
    else { return nil }

    var dict: [String: String] = [:]
    for item in items {
        dict[item.name] = item.value ?? ""
    }

    guard let path = dict.removeValue(forKey: AppRouteConstants.pathKey),
          let function = dict.removeValue(forKey: AppRouteConstants.functionKey)
    else { return nil }

    return RouteComponents(path: path, function: function, params: dict)
}

@MainActor
public struct AppRoute: Hashable, Codable, NavigationRoute {
    public let rawValue: String
    public let module: String

    // Khởi tạo public để các module khác có thể dùng
    public init(_ rawValue: String, module: String = "main_app") {
        self.rawValue = rawValue
        self.module = module
    }

    /// `true` nếu route này mang tham số (được encode bằng getRouteQueryParams).
    public var isParamsRoute: Bool {
        rawValue.hasPrefix(AppRouteConstants.paramsRoutePrefix)
    }

    /// Parse tham số của route. `nil` nếu không phải params-route hợp lệ.
    /// Dùng chung một chỗ thay vì lặp lại URLComponents ở từng router.
    public func decoded() -> RouteComponents? {
        decodeRouteQueryParams(rawValue)
    }
}
