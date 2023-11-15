import Cocoa
import Quartz

class Dabadoo: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var focusObserver: WindowChangeObserver
    private var borderWindow: BorderWindow

    private func handleWindowChanged(frame: NSRect?) {
        if let frame = frame {
            drawBorder(frame: frame)
        }
    }

    override init() {
        let config = Config.loadFromFile()

        let borderColor = NSColor.fromHex(hexRGBA: config.appearance.border_color) ?? NSColor.blue

        let placement: BorderWindow.Placement = switch config.appearance.border_position {
        case .inset:
            BorderWindow.Placement.inset
        case .outset:
            BorderWindow.Placement.outset
        case .inline:
            BorderWindow.Placement.inline
        }

        let layer: BorderWindow.Layer = switch config.appearance.border_layer {
        case .front:
            BorderWindow.Layer.front
        case .back:
            BorderWindow.Layer.back
        }

        borderWindow = BorderWindow(
            color: borderColor,
            width: config.appearance.border_thickness,
            cornerRadius: config.appearance.border_radius,
            layer: layer,
            placement: placement
        )

        focusObserver = switch config.observer.type {
        case .timer:
            TimedWindowObserver(interval: config.observer.timer_interval)
        case .window:
            FocusedWindowObserver()
        }

        super.init()
        focusObserver.onChange(callback: handleWindowChanged)
    }

    func applicationDidFinishLaunching(_: Notification) {}

    func drawBorder(frame: NSRect) {
        borderWindow.drawBorder(frame: frame)
    }
}
