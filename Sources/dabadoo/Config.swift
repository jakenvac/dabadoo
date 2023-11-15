import Foundation
import Yams

struct Config: Codable {
    enum ObserverType: String, Codable {
        case timer
        case window
    }

    struct ObserverConfig: Codable {
        var type: ObserverType = .timer
        var timer_interval: Double = 0.5

        init() {}

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decodeIfPresent(ObserverType.self, forKey: .type) ?? .timer
            timer_interval =
                try container.decodeIfPresent(Double.self, forKey: .timer_interval) ?? 0.5
        }
    }

    enum BorderPositionConfig: String, Codable {
        case inline
        case inset
        case outset
    }

    enum BorderLayerConfig: String, Codable {
        case front
        case back
    }

    struct AppearanceConfig: Codable {
        var border_radius: Float = 12
        var border_thickness: Float = 6
        var border_color: String = "#FFAACC"
        var border_position: BorderPositionConfig = .inline
        var border_layer: BorderLayerConfig = .back

        init() {}

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            border_radius = try container.decodeIfPresent(Float.self, forKey: .border_radius) ?? 12

            border_thickness =
                try container.decodeIfPresent(Float.self, forKey: .border_thickness) ?? 6

            border_color =
                try container.decodeIfPresent(String.self, forKey: .border_color) ?? "#FFAACC"

            border_position =
                try container.decodeIfPresent(
                    BorderPositionConfig.self, forKey: .border_position
                ) ?? .inline

            border_layer =
                try container.decodeIfPresent(
                    BorderLayerConfig.self, forKey: .border_layer
                ) ?? .back
        }
    }

    var appearance: AppearanceConfig = .init()
    var observer: ObserverConfig = .init()

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appearance = try container.decodeIfPresent(AppearanceConfig.self, forKey: .appearance)
            ?? AppearanceConfig()
        observer = try container.decodeIfPresent(ObserverConfig.self, forKey: .observer)
            ?? ObserverConfig()
    }
}

extension Config {
    private static func getConfigUrl(path: String?) -> URL {
        if let path = path {
            return URL(fileURLWithPath: path)
        }
        let fman = FileManager.default
        return fman.homeDirectoryForCurrentUser
            .appendingPathComponent(".config")
            .appendingPathComponent("dabadoo")
            .appendingPathComponent("config.yaml")
    }

    static func loadFromFile(filePath: String? = nil) -> Config {
        let configPath = getConfigUrl(path: filePath)

        guard let yaml = try? String(contentsOf: configPath) else {
            return Config()
        }

        let decoder = YAMLDecoder()
        do {
            let decoded = try decoder.decode(Config.self, from: yaml)
            return decoded
        } catch {
            return Config()
        }
    }
}
