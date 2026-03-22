import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: barWindow
        property var modelData: modelData
        anchors { top: true; left: true; right: true }
        height: zyuTheme.bar_height + (zyuTheme.floating_feel ? 20 : 0)
        color: "transparent"
        exclusionMode: ExclusionMode.Exclusive
        WlrLayershell.layer: WlrLayer.Top

        Rectangle {
            id: barRect
            anchors {
                fill: parent
                topMargin:    zyuTheme.floating_feel ? 10 : 0
                leftMargin:   zyuTheme.floating_feel ? 15 : 0
                rightMargin:  zyuTheme.floating_feel ? 15 : 0
                bottomMargin: zyuTheme.floating_feel ? 5  : 0
            }
            color:   zyuTheme.bar_bg
            radius:  zyuTheme.rounding
            opacity: 0.95

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin:  15
                anchors.rightMargin: 15
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    height: parent.height
                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            width: 80; height: 32; radius: 8
                            color: zyuTheme.widget_bg
                            Text {
                                id: timeText
                                anchors.centerIn: parent
                                color: zyuTheme.bar_fg
                                font: zyuTheme.mainFont
                                text: new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                                Timer {
                                    interval: 60000; running: true; repeat: true
                                    onTriggered: timeText.text = new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})
                                }
                            }
                        }
                    }
                }

                Row {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 6
                    Repeater {
                        model: Hyprland.workspaces
                        delegate: Rectangle {
                            property bool isActive: modelData.id === Hyprland.focusedMonitor?.activeWorkspace?.id
                            width: 38; height: 32; radius: 6
                            color: isActive ? zyuTheme.accent : zyuTheme.widget_bg
                            Behavior on color { ColorAnimation { duration: 150 } }
                            Text {
                                anchors.centerIn: parent
                                text: isActive ? "●" : "○"
                                color: isActive ? "#1a1a1a" : zyuTheme.bar_fg
                                font: zyuTheme.mainFont
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch("workspace " + modelData.id)
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: parent.height
                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            width: 40; height: 32; radius: 8
                            color: dashboardState.show ? zyuTheme.accent : zyuTheme.widget_bg
                            Behavior on color { ColorAnimation { duration: 150 } }
                            Text {
                                text: "󰕮"
                                anchors.centerIn: parent
                                color: dashboardState.show ? "#1a1a1a" : zyuTheme.bar_fg
                                font.pixelSize: 18
                                font.family: "JetBrainsMono Nerd Font"
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: dashboardState.show = !dashboardState.show
                            }
                        }
                    }
                }
            }
        }
    }
}
