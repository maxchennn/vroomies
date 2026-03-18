import QtQuick
import Quickshell

ShellRoot {
    Loader {
        source: "time.qml"
    }

    Loader {
        source: "linux.qml"
    }
}
