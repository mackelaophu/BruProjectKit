//
//  M3BottomSheet.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI
public struct BottomSheetEntity {
    var title: String
    var titleLeft: String?
    var titleRight: String?
    var actionLeft: (() -> Void)?
    var actionRight: (() -> Void)?
    var unImplAction: (() -> Void)? = nil
    var disableRightButton: Binding<Bool>?
    public init(title: String, titleLeft: String? = nil, titleRight: String? = nil, disableRightButton: Binding<Bool>? = nil, actionLeft: (() -> Void)? = nil, actionRight: (() -> Void)? = nil, unImplAction: (() -> Void)? = nil) {
        self.title = title
        self.titleLeft = titleLeft
        self.titleRight = titleRight
        self.actionLeft = actionLeft
        self.actionRight = actionRight
        self.disableRightButton = disableRightButton
        self.unImplAction = unImplAction
    }
}
public struct M3BottomSheet<ToggleView:View,Content:View>: View {
    @Binding var showSheet:Bool
    @Environment(\.appTheme) private var theme
    let entity: BottomSheetEntity
    let content: Content
    let toggleView: ToggleView
    public init(_ showSheet: Binding<Bool>,entity: BottomSheetEntity,@ViewBuilder content: ()-> Content, @ViewBuilder toggleView:  ()->  ToggleView) {
        self.entity = entity
        self.content = content()
        self.toggleView = toggleView()
        self._showSheet = showSheet
    }
    public var body: some View {
        Button(action: {
            showSheet.toggle()
            entity.unImplAction?()
        }) { toggleView.frame(minHeight: 48) }
            .sheet(isPresented: $showSheet) {
                VStack(spacing: 0) {
                    Capsule()
                        .fill(theme.colors.onSurfaceVarColor.opacity(0.4))
                        .frame(width: 32, height: 4)
                        .padding(.top, 8)
                    ZStack {
                        Text(entity.title)
                            .appStyle(.headlineSm)
                            .foregroundColor(theme.colors.onSurfaceColor)
                            .lineLimit(1)

                        HStack(spacing: 0) {
                            if let titleLeft = entity.titleLeft {
                                TextButton(label : titleLeft) {
                                    entity.actionLeft?()
                                }
                            }
                            Spacer(minLength: 16)
                            if let titleRight = entity.titleRight {
                                TextButton(
                                    label: titleRight
                                ) {
                                    entity.actionRight?()
                                }
                                .disabled(entity.disableRightButton?.wrappedValue ?? false)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 22)
                    ScrollView {
                        content
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .scrollIndicators(.hidden)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .presentationBackground(theme.colors.surfContainerLowColor)
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(theme.radius.defaultRadius)
                .presentationDragIndicator(.hidden)
            }
    }
}

#Preview {
    @Previewable @State var showSheet:Bool = false
    @Previewable @State var disableButtonRight:Bool = true
    M3BottomSheet($showSheet, entity: BottomSheetEntity(title: "create exercises", titleLeft: "Đóng", titleRight: "lưu", disableRightButton: $disableButtonRight, actionLeft: {
        showSheet = false
        disableButtonRight.toggle()
    }, actionRight: {disableButtonRight.toggle()})) {
        Text("a")
    } toggleView: {
        Text("toggle here")
    }
}
