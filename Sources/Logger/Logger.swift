import Foundation
import SwiftUI

public enum LogLevel: Int {
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
    func publish(message: String, obj: Any, level: LogLevel)
}

public struct LoggerMock: LoggerProvider {
    public func publish(message: String, obj: Any, level: LogLevel) {}
}

public final class Logger: LoggerProvider {
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
        DispatchQueue.global(qos: .background).async { [weak self] in
            let lineStr = line != nil ? "[\(line ?? 0)]" : ""
            self?.publish(
                message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",

                obj: obj,
                level: .debug
            )
        }
    }

    public func info(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let lineStr = line != nil ? "[\(line ?? 0)]" : ""
            self?.publish(
                message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",
                obj: obj,
                level: .info
            )
        }
    }

    public func warning(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let lineStr = line != nil ? "[\(line ?? 0)]" : ""
            self?.publish(
                message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",
                obj: obj,
                level: .warning
            )
        }
    }

    public func error(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let lineStr = line != nil ? "[\(line ?? 0)]" : ""
            self?.publish(
                message: "\(Logger.getFileName(path)).\(Logger.getFunctionName(functionName))\(lineStr):",
                obj: obj,
                level: .error
            )
        }
    }

    public func publish(message: String, obj: Any, level: LogLevel) {
        guard level.rawValue >= logLevel.rawValue else {
            return
        }
        print("\(level.getEmoj()) \(message)", obj)
    }

    public struct InView: View {
        public init(_ str: Any) {
            Logger.shared.info(str)
        }

        public var body: some View {
            AnyView(EmptyView().frame(width: 0, height: 0))
        }
    }
}

public struct LogModifier: ViewModifier {
    public init(obj: Any) {
        Logger.shared.debug(obj)
    }

    public func body(content: Content) -> some View {
        return content
    }
}

public extension View {
    func log(_ obj: Any) -> some View {
        modifier(LogModifier(obj: obj))
    }
}
