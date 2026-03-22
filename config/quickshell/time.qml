import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    PanelWindow {
        id: timeWindow
        screen: Quickshell.screens[0]

        anchors { bottom: true; left: true }
        margins { bottom: 85; left: 115 }
        implicitWidth: 600
        implicitHeight: 200
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "pure-time"

        property color colPrimary: "#e8f4f8"
        property color colSecond:  "#e8f4f8"
        property color colDate:    "#e8f4f8"

        Component.onCompleted: loadColors()

        function loadColors() {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + Quickshell.env("HOME") + "/.config/quickshell/Colors/colors.json")
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 0) {
                    try {
                        var c = JSON.parse(xhr.responseText)
                        if (c.primary)            colPrimary = c.primary
                        if (c.tertiary)           colSecond  = c.tertiary
                        if (c.on_surface_variant) colDate    = c.on_surface_variant
                    } catch(e) {}
                }
            }
            xhr.send()
        }

        Column {
            anchors.bottom: parent.bottom
            spacing: 4

            Row {
                spacing: 0
                anchors.left: parent.left

                Text {
                    id: hourLabel
                    text: Qt.formatDateTime(new Date(), "HH")
                    font.family: "Oxanium"
                    font.pixelSize: 120
                    font.weight: Font.Black
                    color: timeWindow.colPrimary
                    opacity: 1

                    Behavior on color { ColorAnimation { duration: 500 } }
                }

                Text {
                    text: ":"
                    font.family: "Oxanium"
                    font.pixelSize: 100
                    font.weight: Font.Black
                    color: timeWindow.colDate
                    opacity: 1
                    anchors.verticalCenter: parent.verticalCenter
                    bottomPadding: 8
                }

                Text {
                    id: minLabel
                    text: Qt.formatDateTime(new Date(), "mm")
                    font.family: "Oxanium"
                    font.pixelSize: 120
                    font.weight: Font.Black
                    color: timeWindow.colSecond
                    opacity: 1

                    Behavior on color { ColorAnimation { duration: 500 } }
                }
            }

            Row {
                anchors.left: parent.left
                spacing: 8

                Rectangle {
                    width: 20
                    height: 1
                    color: timeWindow.colPrimary
                    opacity: 1
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color { ColorAnimation { duration: 500 } }
                }

                Text {
                    id: dateLabel
                    text: Qt.formatDateTime(new Date(), "dddd · MMMM d").toUpperCase()
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    font.letterSpacing: 5
                    color: timeWindow.colDate
                    opacity: 1
                }
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                var now = new Date()
                hourLabel.text = Qt.formatDateTime(now, "HH")
                minLabel.text = Qt.formatDateTime(now, "mm")
                dateLabel.text = Qt.formatDateTime(now, "dddd · MMMM d").toUpperCase()
            }
        }
    }
}
