#if DEBUG
import SwiftUI
import Common

// Previews nằm trong Common.framework — chỉ load Common.dylib
// Không bao giờ import framework khác ở đây

#Preview("Keychain Demo") {
    Text("Common module preview")
        .padding()
}
#endif
