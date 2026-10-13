import CoreText
import SwiftUI

enum Theme {
    static let fontName = "WalterTurncoat"

    /// The hand-lettered font, scaled with Dynamic Type.
    static func font(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom(fontName, size: size, relativeTo: style)
    }

    /// Registers the bundled font, so the app needs no hand-written Info.plist.
    static func registerFont() {
        guard let url = Bundle.main.url(forResource: fontName, withExtension: "ttf") else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}
