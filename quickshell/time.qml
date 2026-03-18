import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: timeWindow
            anchors { bottom: true; left: true }
            margins { bottom: 85; left: 115 }
            implicitWidth: 600; implicitHeight: 300
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "pure-archivo-centered"

            Column {
                anchors.bottom: parent.bottom
                spacing: -10

                Row {
                    id: timeRow
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: hourLabel
                        text: Qt.formatDateTime(new Date(), "HH")
                        font.family: "Archivo Black" 
                        font.pixelSize: 130
                        font.weight: Font.Black
                        color: "#FFFFFF"
                    }

                    Text {
                        text: ":"
                        font.family: "Archivo Black"
                        font.pixelSize: 110
                        font.weight: Font.Black
                        color: "#FFFFFF"
                        opacity: 1
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id: minLabel
                        text: Qt.formatDateTime(new Date(), "mm")
                        font.family: "Archivo Black"
                        font.pixelSize: 130
                        font.weight: Font.Black
                        color: "#FFFFFF"
                    }
                }

                Text {
                    id: dateLabel
                    text: Qt.formatDateTime(new Date(), "dddd // MMMM dd").toUpperCase()
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    font.letterSpacing: 9
                    color: "white"
                    opacity: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: {
                    var now = new Date();
                    hourLabel.text = Qt.formatDateTime(now, "HH");
                    minLabel.text = Qt.formatDateTime(now, "mm");
                    dateLabel.text = Qt.formatDateTime(now, "dddd // MMMM dd").toUpperCase();
                }
            }
        }
    }
}
