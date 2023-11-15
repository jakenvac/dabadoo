import Cocoa
import Quartz

let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true] as CFDictionary
if AXIsProcessTrustedWithOptions(options) {
  let app = NSApplication.shared
  let delegate = Dabadoo()

  app.delegate = delegate as NSApplicationDelegate
  // app.setActivationPolicy(.regular)  // Make sure the app is a regular app that appears in Dock
  app.activate(ignoringOtherApps: true)  // Activate the app

  app.run()
} else {
  print("App does not have permission to use accessibility API")
}
