# Logger

Provides a logger for your Swift project


## Install
Add Logger as a Swift package dependency
```
https://github.com/lindebrothers/Logger
```

## How to use it

### Methods

``` Swift
public func publish(message: String, obj: Any, level: LogLevel)
```

#### Convenient methods
Debug
``` Swift
public func debug(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file)
```

Info
``` Swift
public func info(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file)
```

Warning
``` Swift
public func warning(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file)
```

Error
``` Swift
public func error(_ obj: Any, functionName: String? = #function, line: Int? = #line, path: String? = #file)
```


### Log from a SwiftUI View
```Swift
struct ContentView: View {
    var body: some View {
        Logger.InView("my message")
    }
}

```
or use the `log` modifier
```Swift 
struct ContentView: View {
    var body: some View {
        Color.log("My message")
    }
}
```

