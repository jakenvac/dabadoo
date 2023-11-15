import Foundation

func log(_ items: Any ..., filePath: String = #file) {
    let file = URL(fileURLWithPath: filePath).lastPathComponent
    print("[\(file)]\n  ", items)
}
