import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: w
            property var modelData
            screen: modelData

            anchors {
                right: true
                bottom: true
            }

            margins {
                right: 50
                bottom: 80 
            }

            implicitWidth: content.width
            implicitHeight: content.height

            color: "transparent"
            
            WlrLayershell.layer: WlrLayer.Background

            ColumnLayout {
                id: content
                spacing: 0 

                Text {
                    text: "Activate Linux"
                    color: "#88ffffff"
                    font.pixelSize: 40 
                    font.family: "VT323"
                    renderType: Text.QtRendering
                    antialiasing: false 
                    font.weight: Font.Bold
                }

                Text {
                    text: "Go to Settings to activate Linux."
                    color: "#88ffffff"
                    font.pixelSize: 16
                    font.family: "Monospace"
                    renderType: Text.QtRendering
                    antialiasing: false
                }
            }
        }
    }
}
