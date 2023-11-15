import Cocoa
import Quartz

private func windowFocusedChangedTrampoline(
    observer: AXObserver, element: AXUIElement, notification: CFString,
    refcon: UnsafeMutableRawPointer?
) {
    let fwo = Unmanaged<FocusedWindowObserver>.fromOpaque(refcon!).takeUnretainedValue()
    fwo.windowFocusChangedCallback(observer: observer, element: element, notification: notification)
}

class FocusedWindowObserver: WindowChangeObserver {
    private var windowChangedObserver: AXObserver?
    private var onFocusChanged: WindowChangeObserver.OnChangeHandler?
    private var focusedWindow: AXUIElement?

    init() {}

    deinit {
        // TODO: remove event listener from observer before we make it nil
        windowChangedObserver = nil
        onFocusChanged = nil
        focusedWindow = nil
    }

    func onChange(callback: @escaping OnChangeHandler) {
        onFocusChanged = callback
        updateFocusedWindow()
    }

    func removeOnChange() {
        onFocusChanged = nil
    }

    private func createFocusChangedObserver() -> AXObserver? {
        guard let focusedWindow = focusedWindow else {
            return nil
        }

        var pid: pid_t = 0
        AXUIElementGetPid(focusedWindow, &pid)

        var observer: AXObserver?
        guard AXObserverCreate(pid, windowFocusedChangedTrampoline, &observer) == .success,
              let observer = observer
        else {
            return nil
        }

        let selfRef = Unmanaged.passUnretained(self).toOpaque()
        AXObserverAddNotification(
            observer, focusedWindow, kAXFocusedWindowChangedNotification as CFString, selfRef
        )

        CFRunLoopAddSource(
            CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observer), .defaultMode
        )

        return observer
    }

    private func updateFocusedWindow() {
        let fwin = WindowUtils.getFocusedWindow()
        focusedWindow = fwin
        let frame: NSRect? = if let win = fwin {
            WindowUtils.getWindowFrame(window: win)
        } else {
            nil
        }
        windowChangedObserver = createFocusChangedObserver()
        onFocusChanged?(frame)
    }

    fileprivate func windowFocusChangedCallback(
        observer _: AXObserver, element _: AXUIElement, notification _: CFString
    ) {
        updateFocusedWindow()
    }
}
