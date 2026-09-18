//
//  HTMLWebView.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 2/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//


import SwiftUI
import WebKit
import Common

/// A UIViewRepresentable wrapper for WKWebView to load HTML strings.
public struct HTMLWebView: UIViewRepresentable {
    public let htmlContent: String
    public let baseURL: URL?
    public var onLoadFinished: (() -> Void)?
    
    public init(htmlContent: String, baseURL: URL? = nil, onLoadFinished: (() -> Void)? = nil) {
        self.htmlContent = htmlContent
        self.baseURL = baseURL
        self.onLoadFinished = onLoadFinished
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLWebView
        
        init(_ parent: HTMLWebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onLoadFinished?()
        }
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        
        // Đẩy việc load ra background/next run loop để không block main thread
        // Giúp animation chuyển trang mượt mà hơn
        DispatchQueue.main.async {
            webView.loadHTMLString(htmlContent, baseURL: baseURL)
        }
        
        return webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // Do not call loadHTMLString here to prevent reloading every time SwiftUI updates
    }
}

/// A screen that displays HTML content, suitable for Terms of Service, Privacy Policy, or loading `index.html`.
public struct HTMLViewerScreen: View {
    public let title: String
    public let htmlContent: String
    @Environment(\.appTheme) private var theme
    @State private var uistate: UIState = .loading
    @State private var allowWebViewCreation: Bool = false
    
    public init(title: String = "", htmlContent: String) {
        self.title = title
        self.htmlContent = htmlContent
    }
    
    public var body: some View {
        ZStack {
            switch uistate {
            case .done:
                HTMLWebView(htmlContent: htmlContent)
            default:
                HTMLSkeletonView()
            }
        }
        .onAppear {
            // Đợi animation chuyển trang (navigation push) hoàn thành rồi mới tạo WKWebView
            // Tốc độ chuyển trang mặc định của iOS là khoảng 0.3 - 0.4s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                uistate = .done
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(title)
                        .appStyle(.headlineSm)
                        .foregroundColor(theme.colors.primaryColor)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension HTMLViewerScreen {
    /// Convenience initializer to load HTML from a local file in the app bundle.
    public init(title: String = "", localFileName: String, bundle: Bundle? = nil) {
        self.title = title

        // Use Bundle.module (Tuist-generated) to correctly resolve resources
        // in a static library target. Bundle(for:) returns Bundle.main for
        // static libs and would fail to find files in the generated resource bundle.
        let targetBundle = bundle ?? Bundle.module

        if let url = targetBundle.url(forResource: localFileName, withExtension: "html"),
           let content = try? String(contentsOf: url) {
            self.htmlContent = content
        } else {
            self.htmlContent = "<html><body style=\"font-family: sans-serif; padding: 20px;\"><h2>Failed to load \(localFileName).html</h2><p>Please check if the file exists and is added to the target's resources.</p></body></html>"
        }
    }
}

#Preview {
    NavigationView {
        HTMLViewerScreen(
            title: "Sample HTML",
            htmlContent: "<html><body style=\"font-family: sans-serif; padding: 20px;\"><h1>Hello, World!</h1><p>This is a sample HTML content passed in.</p></body></html>"
        )
    }
}

/// A Facebook-style skeleton loader for HTML/Text content
struct HTMLSkeletonView: View {
    @Environment(\.appTheme) private var theme
    @State private var isBlinking = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(0..<4, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 12) {
                    // Tiêu đề giả
                    RoundedRectangle(cornerRadius: 6)
                        .fill(theme.colors.outlineVariantColor.opacity(0.4))
                        .frame(maxWidth: 150)
                        .frame(height: 24)
                    
                    // Các dòng chữ giả
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.colors.outlineVariantColor.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 16)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.colors.outlineVariantColor.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 16)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.colors.outlineVariantColor.opacity(0.2))
                            .frame(maxWidth: 250)
                            .frame(height: 16)
                    }
                }
            }
            Spacer()
        }
        .padding(24)
        .opacity(isBlinking ? 0.4 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isBlinking = true
            }
        }
    }
}

