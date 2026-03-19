import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    property string username: ""

    function getUsername() {
        try {
            const envUser = Process.env["USER"]
            username = envUser ? envUser : "USER"
        } catch (e) {
            username = "USER"
        }
    }

    Component.onCompleted: {
        getUsername()
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: welcomeWindow
            property var screenModel: modelData
            screen: screenModel

            color: "transparent"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.anchors: Quickshell.AllAnchors

            implicitWidth: screen ? screen.width : 1920
            implicitHeight: screen ? screen.height : 1080

            Rectangle {
                id: card
                width: 480
                height: 250
                radius: 32
                anchors.centerIn: parent
                color: "#11111b"
                border.color: "#313244"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 35
                    spacing: 12

                    Text {
                        text: "WELCOME " + username.toUpperCase()
                        font.pixelSize: 32
                        font.family: "Oxanium"
                        font.weight: Font.Black
                        color: "#ffffff"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "THE SYSTEM IS READY"
                        font.pixelSize: 12
                        font.family: "JetBrains Mono"
                        font.letterSpacing: 4
                        font.weight: Font.Bold
                        color: "#ffffff"
                        opacity: 0.5
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Item { Layout.fillHeight: true }

                    Rectangle {
                        id: startButton
                        width: 220
                        height: 50
                        radius: 15
                        color: btnMouse.containsMouse ? "#6e3aff" : "#1e1e2e"
                        Layout.alignment: Qt.AlignHCenter

                        Behavior on color { ColorAnimation { duration: 200 } }

                        Text {
                            anchors.centerIn: parent
                            text: "LET'S GET STARTED"
                            font.pixelSize: 13
                            font.family: "JetBrains Mono"
                            font.weight: Font.Bold
                            font.letterSpacing: 1
                            color: "#ffffff"

                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        MouseArea {
                            id: btnMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: fadeOut.start()
                        }
                    }
                }

                opacity: 0
                scale: 0.9

                ParallelAnimation {
                    running: true
                    NumberAnimation { target: card; property: "opacity"; from: 0; to: 1; duration: 1000; easing.type: Easing.OutQuart }
                    NumberAnimation { target: card; property: "scale"; from: 0.9; to: 1; duration: 1000; easing.type: Easing.OutBack }
                }

                Timer {
                    id: autoCloseTimer
                    interval: 10000
                    running: true
                    onTriggered: fadeOut.start()
                }

                SequentialAnimation {
                    id: fadeOut
                    NumberAnimation { target: card; property: "opacity"; to: 0; duration: 600; easing.type: Easing.InQuart }
                    NumberAnimation { target: card; property: "scale"; to: 0.8; duration: 600; easing.type: Easing.InBack }
                    onStopped: welcomeWindow.visible = false
                }
            }
        }
    }
}
