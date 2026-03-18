import QtQuick // Bu satır Loader hatasını çözer kanka
import Quickshell

ShellRoot {
    // Saat
    Loader {
        source: "time.qml"
    }

    // Activate Linux
    Loader {
        source: "linux.qml"
    }
}
