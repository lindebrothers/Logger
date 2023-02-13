import Foundation
import SwiftUI

public enum LogLevel: Int, Sendable {
    case none, debug, info, warning, error

    func getEmoj() -> String {
        switch self {
        case .debug:
            return "🏷"
        case .info:
            return "💬"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        default:
            return ""
        }
    }
}

public protocol LoggerProvider {
    func publish(message: String, obj: Any, level: LogLevel) async
}

public struct LoggerMock: LoggerProvider {
    public init() {}
    public func publish(message: String, obj: Any, level: LogLevel) {}
}

public final actor Logger: LoggerProvider {
    public init() {}
    public var logLevel: LogLevel {
#if DEBUG
        return .debug
#else
        return .none
#endif
    }

    public static var shared: Logger = {
        Logger()
    }()

    public static func getFileName(_ path: String?) -> String {
        guard let path = path else { return "" }
        return (path as NSString).lastPathComponent.components(separatedBy: ".")[0]
    }

    public static func getFunctionName(_ name: String?) -> String {
        guard let name = name else { return "" }
        return name.components(separatedBy: "(")[0]
    }

    public func debug(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file) {
        let lineStr = line != nil ? "[\(line ?? 0)]" : ""
        publish(
            message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",

            obj: obj,
            level: .debug
        )
    }

    public func info(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file) {
        let lineStr = line != nil ? "[\(line ?? 0)]" : ""
        publish(
            message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",
            obj: obj,
            level: .info
        )
    }

    public func warning(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file) {
        let lineStr = line != nil ? "[\(line ?? 0)]" : ""
        publish(
            message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",
            obj: obj,
            level: .warning
        )
    }

    public func error(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file) {
        let lineStr = line != nil ? "[\(line ?? 0)]" : ""
        publish(
            message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",
            obj: obj,
            level: .error
        )
    }

    public func publish(message: String, obj: Any, level: LogLevel) {
        guard level.rawValue >= logLevel.rawValue else {
            return
        }
        print("\(level.getEmoj()) \(message)", obj)
    }
}
