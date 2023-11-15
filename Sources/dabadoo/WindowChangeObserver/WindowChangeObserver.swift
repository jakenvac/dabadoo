import Cocoa

protocol WindowChangeObserver {
    typealias OnChangeHandler = (NSRect?) -> Void

    func onChange(callback: @escaping OnChangeHandler)
    func removeOnChange()
}
