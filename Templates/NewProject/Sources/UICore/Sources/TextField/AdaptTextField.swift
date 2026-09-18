//
//  File.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 4/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//
import SwiftUI
public struct AdaptTextField :View {
    var isSecureText: Bool
    @Binding var isShowingPassword: Bool
    let placeHolder: String
    @Binding var text: String
    public init(isSecureText: Bool = false, isShowingPassword: Binding<Bool> = .constant(false), placeHolder: String, text: Binding<String>) {
        self._isShowingPassword = isShowingPassword
        self.placeHolder = placeHolder
        self._text = text
        self.isSecureText = isSecureText
    }
    @ViewBuilder
    private func buildSecureTF(isShowingPassword: Binding<Bool>, placeHolder: String, text: Binding<String>) -> some View {
        HStack {
            if isShowingPassword.wrappedValue {
                TextField(placeHolder, text: text)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .clearText(text)
            } else {
                
                SecureField(placeHolder, text: text)
                    .textContentType(.password)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clearText(text)
            }
            
            // 4. Nút con mắt để toggle (bật/tắt) trạng thái
            Button {
                isShowingPassword.wrappedValue.toggle()
            } label: {
                Image(systemName: isShowingPassword.wrappedValue ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 16)
        }
    }
    @ViewBuilder
    private func buildTF(placeHolder: String, text: Binding<String>) -> some View {
        TextField(placeHolder, text: text)
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .clearText(text)
            .padding(.trailing, 16)
    }
    public var body: some View {
        if isSecureText {
            buildSecureTF(isShowingPassword: _isShowingPassword, placeHolder: placeHolder, text: _text)
        } else {
            buildTF(placeHolder: placeHolder, text: _text)
        }
    }
}


