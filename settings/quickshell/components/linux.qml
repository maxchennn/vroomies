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
    WlrLayershell.namespace: "activate-linux-widget"
    WlrLayershell.exclusiveZone: -1
    color: "transparent"

    QtObject {
        id: md3
        property color surface_container: "#271d1c"
        property color on_surface:        "#f1dfdc"
        property color primary:           "#ffb4a8"
        property color outline_variant:   "#534341"
    }

    FileView {
        path: Quickshell.env("HOME") + "/.config/quickshell/Colors/colors.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                var c = JSON.parse(text())
                if (c.surface_container) md3.surface_container = c.surface_container
                if (c.on_surface)        md3.on_surface        = c.on_surface
                if (c.primary)           md3.primary           = c.primary
                if (c.outline_variant)   md3.outline_variant   = c.outline_variant
            } catch(e) {}
        }
    }

    // ── MD3 Card ──
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 24
        anchors.rightMargin: 24

        width: col.implicitWidth + 24
        height: col.implicitHeight + 20
        radius: 12

        color: Qt.rgba(md3.surface_container.r, md3.surface_container.g, md3.surface_container.b, 0.88)
        border.color: md3.outline_variant
        border.width: 1

        Column {
            id: col
            anchors.centerIn: parent
            spacing: 3

            Text {
                text: "Activate Linux"
                color: md3.primary
                font.family: "Google Sans Flex"
                font.pixelSize: 22
                font.weight: Font.Medium
                font.letterSpacing: 0.1
            }

            Text {
                text: "Go to Settings to activate Linux."
                color: md3.on_surface
                font.family: "Google Sans Flex"
                font.pixelSize: 18
                font.weight: Font.Normal
                opacity: 0.7
            }
        }
    }
}
