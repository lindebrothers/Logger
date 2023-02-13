import SwiftUI
import Logger
@main
struct LoggerExampleApp: App {
    
    init() {
        Task.detached {
            Logger().info("Awesome")
        }
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
