import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

PanelWindow {
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "clock-widget"
    WlrLayershell.exclusiveZone: -1
    color: "transparent"

    SystemClock { id: clock; precision: SystemClock.Seconds }

    QtObject {
        id: md3
        property color primary: "#ffb4a8"
    }

    FileView {
        path: Quickshell.env("HOME") + "/.config/quickshell/Colors/colors.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                var c = JSON.parse(text())
                if (c.primary) md3.primary = c.primary
            } catch(e) {}
        }
    }

    Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 32
        width: 220
        height: 300

        Text {
            id: hourText
            text: Qt.formatTime(clock.date, "HH")
            font.pixelSize: 160
            font.weight: Font.Black
            font.family: "Google Sans Flex"
            color: md3.primary
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Text {
            text: Qt.formatTime(clock.date, "mm")
            font.pixelSize: 160
            font.weight: Font.Black
            font.family: "Google Sans Flex"
            color: md3.primary
            anchors.top: hourText.top
            anchors.left: parent.left
            anchors.topMargin: 130
        }
    }
}
