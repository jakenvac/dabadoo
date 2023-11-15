import Cocoa
import Quartz

struct WindowUtils {
    private init() {}

    static func getScreenSizeForFrame(frame: NSRect) -> NSSize? {
        guard
            let screen = NSScreen.screens.first(where: { screen in
                screen.frame.intersects(frame)
            })
        else {
            return nil
        }
        return screen.frame.size
    }

    private static func getWMCoordsForFrame(frame: NSRect) -> NSRect? {
        guard let screenSize = getScreenSizeForFrame(frame: frame) else {
            return nil
        }
        let screenHeight = screenSize.height
        let newY = screenHeight - frame.height - frame.origin.y
        return NSRect(
            x: frame.origin.x,
            y: newY,
            width: frame.width,
            height: frame.height
        )
    }

    static func getFocusedWindow() -> AXUIElement? {
        guard let frontmostApp = NSWorkspace.shared.frontmostApplication else {
            return nil
        }

        let appElement = AXUIElementCreateApplication(frontmostApp.processIdentifier)

        var focused: AnyObject?
        let windowError = AXUIElementCopyAttributeValue(
            appElement, kAXFocusedWindowAttribute as CFString, &focused
        )

        guard windowError == AXError.success, let focused = focused else {
            return nil
        }

        // swiftlint:disable:next force_cast
        return focused as! AXUIElement?
    }

    static func getWindowFrame(window: AXUIElement) -> NSRect? {
        var positionAttr: AnyObject?
        AXUIElementCopyAttributeValue(
            window, kAXPositionAttribute as CFString, &positionAttr
        )

        var sizeAttr: AnyObject?
        AXUIElementCopyAttributeValue(
            window, kAXSizeAttribute as CFString, &sizeAttr
        )

        guard let positionAttr = positionAttr, let sizeAttr = sizeAttr else {
            return nil
        }

        var point = CGPoint()
        var size = CGSize()

        // swiftlint:disable:next force_cast
        let positionVal = positionAttr as! AXValue

        // swiftlint:disable:next force_cast
        let sizeVal = sizeAttr as! AXValue

        let posSucceeded = AXValueGetValue(positionVal, AXValueType.cgPoint, &point)
        let sizeSucceeded = AXValueGetValue(sizeVal, AXValueType.cgSize, &size)

        guard posSucceeded, sizeSucceeded else {
            return nil
        }

        return WindowUtils.getWMCoordsForFrame(
            frame: NSRect(x: point.x, y: point.y, width: size.width, height: size.height)
        )
    }
}
