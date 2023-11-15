import Cocoa
import Quartz

class TimedWindowObserver: WindowChangeObserver {
    private var onTimerElapsed: WindowChangeObserver.OnChangeHandler?
    private var timer: Timer?

    init(interval: Double) {
        timer = Timer.scheduledTimer(
            timeInterval: interval,
            target: self,
            selector: #selector(updateFocusedWindow),
            userInfo: nil,
            repeats: true
        )
    }

    deinit {
        timer?.invalidate()
        removeOnChange()
    }

    func onChange(callback: @escaping OnChangeHandler) {
        onTimerElapsed = callback
        updateFocusedWindow()
    }

    func removeOnChange() {
        onTimerElapsed = nil
    }

    @objc private func updateFocusedWindow() {
        let fwin = WindowUtils.getFocusedWindow()
        let frame: NSRect? = if let win = fwin {
            WindowUtils.getWindowFrame(window: win)
        } else {
            nil
        }
        onTimerElapsed?(frame)
    }
}
