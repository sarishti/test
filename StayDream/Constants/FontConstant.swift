// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  typealias Font = UIFont
#endif

// swiftlint:disable file_length

struct FontConvertible {
  let name: String
  let family: String
  let path: String

  func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  func register() {
    let bundle = Bundle(for: BundleToken.self)

    guard let url = bundle.url(forResource: path, withExtension: nil) else {
      return
    }

    var errorRef: Unmanaged<CFError>?
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, &errorRef)
  }
}

extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if UIFont.fontNames(forFamilyName: font.family).isEmpty {
      font.register()
    }
    #elseif os(OSX)
    if NSFontManager.shared().availableMembers(ofFontFamily: font.family) == nil {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable identifier_name line_length type_body_length
enum FontFamily {
  enum Georgia {
    static let regular = FontConvertible(name: "Georgia", family: "Georgia", path: "georgia_0.ttf")
  }
  enum Tahoma {
    static let normal = FontConvertible(name: "Tahoma", family: "Tahoma", path: "tahoma_0.ttf")
    static let bold = FontConvertible(name: "Tahoma-Bold", family: "Tahoma", path: "TAHOMAB0.TTF")
  }
}
// swiftlint:enable identifier_name line_length type_body_length

private final class BundleToken {}
