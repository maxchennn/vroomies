import QtQuick
import Quickshell
import "Launcher"

ShellRoot {
    Loader { source: "linux.qml" }
    Loader { source: "dock.qml" }
    Loader { source: "time.qml" }
    
}
