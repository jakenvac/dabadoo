import Cocoa
import Quartz

class BorderWindow {
    enum Layer {
        case front
        case back
    }

    enum Placement {
        case outset
        case inset
        case inline
    }

    private var borderFrame: NSRect
    private var borderWindow: NSWindow
    private var borderView: NSBox
    private var placement: Placement

    var frame: NSRect {
        return borderFrame
    }

    init(
        color: NSColor = NSColor.blue,
        width: Float = 2,
        cornerRadius: Float = 10,
        layer: Layer = .front,
        placement: Placement = .inset
    ) {
        let initialFrame = NSRect(x: 0, y: 0, width: 0, height: 0)

        let styleMask: NSWindow.StyleMask = [.borderless, .resizable]
        let window = NSWindow(
            contentRect: initialFrame, styleMask: styleMask, backing: .buffered, defer: false
        )

        window.hasShadow = false
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.level =
            layer == .front
                ? .floating
                : NSWindow.Level(
                    rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.desktopIconWindow)))

        let borderView = NSBox(frame: window.contentView!.bounds)
        borderView.boxType = .custom
        borderView.borderType = .lineBorder
        borderView.borderColor = color
        borderView.borderWidth = CGFloat(width)
        borderView.cornerRadius = CGFloat(cornerRadius)

        window.contentView?.addSubview(borderView)
        window.orderFront(nil)

        borderFrame = initialFrame
        self.borderView = borderView
        borderWindow = window
        self.placement = placement
    }

    private func calculatePlacementForInline(frame: NSRect) -> NSRect {
        let thickness = borderView.borderWidth
        return NSRect(
            x: frame.origin.x - (thickness / 2),
            y: frame.origin.y - (thickness / 2),
            width: frame.width + thickness,
            height: frame.height + thickness
        )
    }

    private func calculatePlacementForOutset(frame: NSRect) -> NSRect {
        let thickness = borderView.borderWidth
        return NSRect(
            x: frame.origin.x - thickness,
            y: frame.origin.y - thickness,
            width: frame.width + (thickness * 2),
            height: frame.height + (thickness * 2)
        )
    }

    private func calculatePlacement(placement: Placement, frame: NSRect) -> NSRect {
        switch placement {
        case .inset: return frame
        case .outset: return calculatePlacementForOutset(frame: frame)
        case .inline: return calculatePlacementForInline(frame: frame)
        }
    }

    func drawBorder(frame: NSRect) {
        if frame != borderFrame {
            borderFrame = frame
            let appliedSize = calculatePlacement(placement: placement, frame: frame)
            borderView.setFrameSize(appliedSize.size)
            borderWindow.setFrame(appliedSize, display: true)
        }
    }
}
