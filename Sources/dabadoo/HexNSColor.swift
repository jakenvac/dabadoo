import Cocoa

func hexToInt(hex: String) -> UInt32? {
  var rgba: UInt32 = 0
  if !Scanner(string: hex).scanHexInt32(&rgba) {
    return nil
  }
  return rgba
}

extension NSColor {
  static func fromHex(hexRGBA: String) -> NSColor? {
    var hex =
      hexRGBA
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "#", with: "")

    guard hex.count == 8 || hex.count == 6 else {
      return nil
    }

    if hex.count == 6 {
      hex = "\(hex)FF"
    }

    guard let rgba = hexToInt(hex: hex) else {
      return nil
    }

    let hexR = (rgba & 0xFF00_0000) >> 24
    let hexG = (rgba & 0x00FF_0000) >> 16
    let hexB = (rgba & 0x0000_FF00) >> 8
    let hexA = (rgba & 0x0000_00FF)

    let red = CGFloat(hexR) / 255.0
    let green = CGFloat(hexG) / 255.0
    let blue = CGFloat(hexB) / 255.0
    let alpha = CGFloat(hexA) / 255.0

    return NSColor(red: red, green: green, blue: blue, alpha: alpha)
  }
}
