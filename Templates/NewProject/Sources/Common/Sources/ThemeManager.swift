//
//  ThemeManager.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 29/5/26.
//  Copyright © 2026 Bru. All rights reserved.
//
import SwiftUI


// MARK: - Theme Manager (ObservableObject để SwiftUI re-render khi đổi theme)

@MainActor
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var current: AppTheme
    enum ThemeMode: String, CaseIterable, Identifiable {
        case light          = "light"
        case dark           = "dark"
        case lightMedium    = "lightMedium"
        case darkMedium     = "darkMedium"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .light:        return "sun.max.fill"
            case .dark:         return "moon.fill"
            case .lightMedium:  return "sun.haze.fill"
            case .darkMedium:   return "moon.haze.fill"
            }
        }

        var appTheme: AppTheme {
            switch self {
            case .light:        return .light
            case .dark:         return .dark
            case .lightMedium:  return .lightMediumContrast
            case .darkMedium:   return .darkMediumContrast
            }
        }
    }
    private init() {
        // Load theme đã lưu từ UserDefaults khi khởi động
        if let raw = UserDefaults.standard.string(forKey: "selectedTheme"),
           let mode = ThemeMode(rawValue: raw) {
            let theme = mode.appTheme
            AppTheme.currentTheme = theme
            self.current = theme
        } else {
            self.current = AppTheme.currentTheme
        }
    }
}

private struct AppThemKey: @MainActor EnvironmentKey {
    @MainActor
    static var defaultValue: AppTheme { .currentTheme }
}

public extension EnvironmentValues {
    @MainActor
    var appTheme: AppTheme {
        get { self[AppThemKey.self] }
        set { self[AppThemKey.self] = newValue }
    }
}
