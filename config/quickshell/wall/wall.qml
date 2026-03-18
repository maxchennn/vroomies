import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
    id: main
    implicitHeight: 500
    implicitWidth: Screen.width
    color: "transparent"

    aboveWindows: true
    exclusionMode: "Ignore"
    exclusiveZone: 1

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    FileView {
        path: Quickshell.shellDir + "/config.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: configs
            property string wallpaper_path
            property string cache_path
            property int number_of_pictures: 5
        }
    }

    FileView {
        path: Quickshell.shellDir + "/../colors.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: matugen
            property var md3: ({})
        }
    }

    function resolvePath(path) {
        if (!path) return "";
        let p = path;
        if (p.startsWith("~")) p = p.replace("~", Quickshell.env("HOME"));
        if (p.includes("$HOME")) p = p.replace("$HOME", Quickshell.env("HOME"));
        return p;
    }

    FolderListModel {
        id: folderModel
        folder: "file://" + resolvePath(configs.wallpaper_path)
        showDirs: false
        nameFilters: ["*.png","*.jpg","*.jpeg","*.webp"]
        sortField: FolderListModel.Name
    }

    ListView {
        id: list
        anchors.fill: parent
        anchors.margins: 40
        focus: true
        model: folderModel
        orientation: ListView.Horizontal
        spacing: 30

        highlightMoveDuration: 400
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: width / 2 - tileWidth / 2
        preferredHighlightEnd: width / 2 - tileWidth / 2

        property int selectedIndex: 0
        property real tileWidth: (width / (configs.number_of_pictures || 5)) - spacing

        delegate: Item {
            id: delegateItem
            width: list.tileWidth
            height: 420
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                color: matugen.md3.surface_container || "#1a1a1a"
                clip: true
                transform: Shear { xFactor: -0.1 }

                scale: index === list.selectedIndex ? 1.05 : 1.0
                Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    source: "file://" + resolvePath(configs.wallpaper_path) + "/" + fileName
                    opacity: status === Image.Ready ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 500 } }
                }
            }
        }

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Right || event.key === Qt.Key_J) {
                selectedIndex = Math.min(selectedIndex + 1, count - 1)
                list.positionViewAtIndex(selectedIndex, ListView.Center)
            } 
            else if (event.key === Qt.Key_Left || event.key === Qt.Key_K) {
                selectedIndex = Math.max(selectedIndex - 1, 0)
                list.positionViewAtIndex(selectedIndex, ListView.Center)
            } 
            else if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
                const path = folderModel.get(selectedIndex, "filePath")
                if (path) {
                    Quickshell.execDetached(["bash", Quickshell.shellDir + "/wall", path])
                    Qt.quit()
                }
            } 
            else if (event.key === Qt.Key_Escape) Qt.quit()
        }
    }
}
