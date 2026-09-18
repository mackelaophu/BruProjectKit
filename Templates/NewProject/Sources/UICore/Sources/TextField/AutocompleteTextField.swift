//
//  AutocompleteTextField.swift
//  UICore
//
//  Created by PhamHai Dang on 11/8/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import SwiftUI
public protocol Searchable: Identifiable {
    var searchText: String { get }
}
public struct Contact: Identifiable, Searchable {
    public let id = UUID()
    public let name: String
    public let phone: String
    public var searchText: String {
        name.removeVietnameseDiacritics().lowercased()
    }
    public init(name: String, phone: String) {
        self.name = name
        self.phone = phone
    }
}
public struct AutocompleteTextField<Item: Searchable, SearchRow: View>: View {
    @Binding var text: String
    let placeHolder: String
    @FocusState private var isFocused: Bool
    
    var searchList: [Item] = []
    let searchRow: (Item) -> SearchRow
    public init(text: Binding<String>, placeHolder: String,searchList: [Item], @ViewBuilder searchRow: @escaping (Item) -> SearchRow) {
        self.searchList = searchList
        self.searchRow = searchRow
        self._text = text
        self.placeHolder = placeHolder
    }
    
    var filteredContacts: [Item] {
        if text.isEmpty { return [] }
        return searchList.filter {
            $0.searchText.contains(text.removeVietnameseDiacritics().lowercased())
        }
    }
    public var body: some View {
        AdaptTextField(placeHolder: placeHolder, text: $text)
            .focused($isFocused)
            .overlay(suggestionDropdown, alignment: .top)
            .padding()
        // Chạm ra ngoài để ẩn bàn phím và dropdown
            .onTapGesture {
                isFocused = false
            }
        // Dropdown phải vẽ đè lên các view khác -> zIndex đặt ở ngoài cùng
            .zIndex(isFocused && !filteredContacts.isEmpty ? 1000 : 0)
    }
    @ViewBuilder
    private var suggestionDropdown: some View {
        if isFocused && !filteredContacts.isEmpty {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredContacts) { contact in
                        Button(action: {
                            // Khi chọn một gợi ý: điền số và ẩn bàn phím
                            text = contact.searchText
                            isFocused = false
                        }) {
                            searchRow(contact)
                        }
                        
                        Divider() // Đường kẻ ngang giữa các dòng
                    }
                }
            }
            .frame(minHeight: 220) // Giới hạn chiều cao dropdown
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            .offset(y: 60) // Đẩy dropdown xuống bên dưới TextField (chiều cao TextField thường ~ 50-60)
        }
    }
}
