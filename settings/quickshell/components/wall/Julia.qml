import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: main
    implicitWidth: Screen.width
    implicitHeight: Screen.height
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    readonly property string wallPath:   Quickshell.env("HOME") + "/Pictures/visions/"
    readonly property string wallScript: Quickshell.env("HOME") + "/.config/quickshell/components/visions/wall.sh"

    property color clrPrimary: "#d5bbfc"
    property color clrBg:      "#0d0d0d"

    FileView {
        path: Quickshell.env("HOME") + "/.config/quickshell/Colors/colors.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                var c = JSON.parse(text())
                if (c.primary)    main.clrPrimary = c.primary
                if (c.background) main.clrBg      = c.background
            } catch(e) {}
        }
    }

    function applyWallpaper(path) {
        Quickshell.execDetached(["bash", wallScript, path])
        main.visible = false
    }

    // Arka plan — tıklayınca kapat
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        MouseArea { anchors.fill: parent; onClicked: main.visible = false }
    }

    Item {
        id: root
        anchors.fill: parent
        focus: true
        Component.onCompleted: root.forceActiveFocus()

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                main.visible = false
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                strip.move(-1)
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                strip.move(1)
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                var path = folderModel.get(strip.focusIndex, "filePath")
                if (path) main.applyWallpaper(path)
                event.accepted = true
            }
        }

        // ── Strip panel ──
        Item {
            id: strip
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 40
            width: parent.width - 24
            height: 140

            property int focusIndex: 0
            property real pos: 0
            property int count: folderModel.count

            // Slot boyutları — orta büyük, yanlara küçülür
            readonly property var slotW:      [196, 126, 104, 88, 74]
            readonly property var slotH:      [110, 71, 59, 50, 42]
            readonly property var slotCX:     [0, 143, 244, 326, 393]
            readonly property var slotBright: [1, 0.56, 0.42, 0.30, 0.22]

            function slotLerp(arr, ao) {
                if (ao >= 4) return arr[4]
                var i = Math.floor(ao)
                var f = ao - i
                return arr[i] + (arr[i + 1] - arr[i]) * f
            }

            function offsetX(off) {
                var ao = Math.abs(off)
                var cx = ao <= 4 ? slotLerp(slotCX, ao) : slotCX[4] + (ao - 4) * 70
                return off < 0 ? -cx : cx
            }

            function move(delta) {
                if (count === 0) return
                focusIndex = Math.max(0, Math.min(count - 1, focusIndex + delta))
            }

            // Smooth chase animasyonu
            FrameAnimation {
                running: strip.pos !== strip.focusIndex
                onTriggered: {
                    var k = 1 - Math.exp(-frameTime / 0.08)
                    var next = strip.pos + (strip.focusIndex - strip.pos) * k
                    strip.pos = Math.abs(next - strip.focusIndex) < 0.001 ? strip.focusIndex : next
                }
            }

            FolderListModel {
                id: folderModel
                folder: "file://" + main.wallPath
                showDirs: false
                nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
            }

            // Mouse wheel
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                property real acc: 0
                onWheel: event => {
                    acc += event.angleDelta.y / 120
                    var notches = Math.trunc(acc)
                    if (notches !== 0) {
                        strip.move(-notches)
                        acc -= notches
                    }
                    event.accepted = true
                }
            }

            // Arka plan
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.92)
                radius: 16
                border.color: "#1e1e2e"
                border.width: 1
            }

            // Tile'lar
            Repeater {
                model: folderModel

                delegate: Item {
                    id: tile
                    required property int index
                    required property string filePath
                    required property string fileName

                    readonly property real off: index - strip.pos
                    readonly property real ao: Math.abs(off)
                    readonly property bool focused: index === strip.focusIndex
                    readonly property real bright: strip.slotLerp(strip.slotBright, ao)

                    width:   strip.slotLerp(strip.slotW, ao)
                    height:  strip.slotLerp(strip.slotH, ao)
                    x:       strip.width / 2 + strip.offsetX(off) - width / 2
                    y:       (strip.height - height) / 2
                    z:       10 - ao
                    visible: ao <= 5
                    opacity: ao <= 4 ? 1 : Math.max(0, 5 - ao)

                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        clip: true
                        color: "#111"
                        border.width: tile.focused ? 2 : 0
                        border.color: main.clrPrimary

                        Image {
                            anchors.fill: parent
                            source: tile.ao <= 5 ? "file://" + tile.filePath : ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            sourceSize: Qt.size(400, 250)
                            smooth: true
                        }

                        // Karartma overlay
                        Rectangle {
                            anchors.fill: parent
                            color: Qt.rgba(0, 0, 0, 1 - tile.bright)
                            radius: 10
                        }

                        // Seçili glow
                        Rectangle {
                            anchors.fill: parent
                            radius: 10
                            color: "transparent"
                            border.width: tile.focused ? 2 : 0
                            border.color: Qt.rgba(main.clrPrimary.r, main.clrPrimary.g, main.clrPrimary.b, 0.6)
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (tile.focused) {
                                    main.applyWallpaper(tile.filePath)
                                } else {
                                    strip.focusIndex = tile.index
                                    root.forceActiveFocus()
                                }
                            }
                        }
                    }
                }
            }

            // Hint text
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                text: "tap to set · ← → to browse · esc to close"
                color: Qt.rgba(1, 1, 1, 0.3)
                font.pixelSize: 10
                font.family: "JetBrains Mono"
                font.letterSpacing: 0.5
            }
        }
    }
}
