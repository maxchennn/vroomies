import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: musicPanel
    visible: true
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; left: true; right: true }
    margins {
        top: root.musicVisible ? 65 : -400
        left: 0
        right: 0
    }
    implicitWidth: 300
    implicitHeight: 420
    color: "transparent"
    focusable: true
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: root.musicVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    Behavior on margins.top { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

    readonly property color walBackground: zyuTheme.bar_bg
    readonly property color walForeground: zyuTheme.bar_fg
    readonly property color walColor5:     zyuTheme.accent
    readonly property color walColor8:     Qt.rgba(zyuTheme.bar_fg.r, zyuTheme.bar_fg.g, zyuTheme.bar_fg.b, 0.5)

    readonly property var player: {
        var players = Mpris.players.values
        if (!players || players.length === 0) return null
        for (var i = 0; i < players.length; i++) {
            if (players[i].isPlaying) return players[i]
        }
        return players[0]
    }

    readonly property bool hasTrack:      player !== null && (player.playbackState === MprisPlaybackState.Playing || player.playbackState === MprisPlaybackState.Paused)
    readonly property bool isPlaying:     player !== null && player.playbackState === MprisPlaybackState.Playing
    readonly property string trackTitle:  player ? (player.trackTitle  || "") : ""
    readonly property string trackArtist: player ? (player.trackArtist || "") : ""
    readonly property string artUrl:      player ? (player.trackArtUrl || "") : ""
    readonly property real trackLength:   player ? (player.length || 0) : 0
    property real trackPosition: 0

    function formatTime(seconds) {
        if (seconds < 0) return "0:00"
        var mins = Math.floor(seconds / 60)
        var secs = Math.floor(seconds % 60)
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }

    Connections {
        target: root
        function onMusicVisibleChanged() {
            if (root.musicVisible) focusTimer.start()
        }
    }
    Timer { id: focusTimer;   interval: 50;  repeat: false; onTriggered: { musicPanel.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive; releaseTimer.start() } }
    Timer { id: releaseTimer; interval: 100; repeat: false; onTriggered: musicPanel.WlrLayershell.keyboardFocus = WlrKeyboardFocus.OnDemand }

    Timer {
        interval: 1000
        running: root.musicVisible && musicPanel.isPlaying
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (musicPanel.player) {
                musicPanel.player.positionChanged()
                musicPanel.trackPosition = musicPanel.player.position
            }
        }
    }

    Item {
        anchors.fill: parent
        focus: root.musicVisible

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                root.musicVisible = false
                event.accepted = true
            } else if (event.key === Qt.Key_Space) {
                if (musicPanel.player && musicPanel.player.canTogglePlaying) musicPanel.player.togglePlaying()
                event.accepted = true
            } else if (event.key === Qt.Key_N) {
                if (musicPanel.player && musicPanel.player.canGoNext) musicPanel.player.next()
                event.accepted = true
            } else if (event.key === Qt.Key_P) {
                if (musicPanel.player && musicPanel.player.canGoPrevious) musicPanel.player.previous()
                event.accepted = true
            }
        }

        // MAIN CARD
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 300
            height: 420
            color: Qt.rgba(musicPanel.walBackground.r, musicPanel.walBackground.g, musicPanel.walBackground.b, 0.95)
            radius: 16
            clip: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Album Art — tam üst, kenarsız, radius yok
                Image {
                    id: albumArt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 280
                    source: musicPanel.artUrl
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: musicPanel.artUrl !== ""
                }
                // Albüm yoksa placeholder
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 280
                    visible: musicPanel.artUrl === ""
                    color: Qt.rgba(musicPanel.walColor5.r, musicPanel.walColor5.g, musicPanel.walColor5.b, 0.08)
                    Text {
                        anchors.centerIn: parent
                        text: "󰎆"
                        color: Qt.rgba(musicPanel.walColor5.r, musicPanel.walColor5.g, musicPanel.walColor5.b, 0.25)
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 72
                    }
                }

                // Title & Artist
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 12
                    Layout.bottomMargin: 8
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    spacing: 3

                    Text {
                        text: musicPanel.trackTitle || "Nothing Playing"
                        color: musicPanel.walForeground
                        font.pixelSize: 15
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                    Text {
                        visible: musicPanel.trackArtist !== ""
                        text: musicPanel.trackArtist
                        color: musicPanel.walColor8
                        font.pixelSize: 12
                        font.family: "JetBrainsMono Nerd Font"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                }

                // Progress Bar
                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 14
                    Layout.rightMargin: 14
                    Layout.bottomMargin: 10
                    spacing: 8
                    visible: musicPanel.hasTrack

                    Text {
                        text: musicPanel.formatTime(musicPanel.trackPosition)
                        color: musicPanel.walColor8
                        font.pixelSize: 10
                        font.family: "JetBrainsMono Nerd Font"
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 3; radius: 2
                        color: Qt.rgba(musicPanel.walForeground.r, musicPanel.walForeground.g, musicPanel.walForeground.b, 0.15)
                        Rectangle {
                            width: musicPanel.trackLength > 0 ? parent.width * (musicPanel.trackPosition / musicPanel.trackLength) : 0
                            height: parent.height; radius: 2
                            color: musicPanel.walColor5
                            Behavior on width { NumberAnimation { duration: 300 } }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                if (musicPanel.trackLength > 0 && musicPanel.player && musicPanel.player.canSeek)
                                    musicPanel.player.position = (mouse.x / parent.width) * musicPanel.trackLength
                            }
                        }
                    }
                    Text {
                        text: musicPanel.formatTime(musicPanel.trackLength)
                        color: musicPanel.walColor8
                        font.pixelSize: 10
                        font.family: "JetBrainsMono Nerd Font"
                    }
                }

                // Controls: Shuffle / Prev / Play / Next / Repeat
                Row {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 14
                    spacing: 14
                    opacity: musicPanel.hasTrack ? 1.0 : 0.35

                    // Shuffle
                    Rectangle {
                        width: 32; height: 32; radius: 8; color: "transparent"
                        Text { anchors.centerIn: parent; text: "󰒝"; color: musicPanel.walForeground; font.pixelSize: 16; font.family: "JetBrainsMono Nerd Font" }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: { if (musicPanel.player) musicPanel.player.shuffle = !musicPanel.player.shuffle }
                        }
                    }

                    // Prev
                    Rectangle {
                        width: 36; height: 36; radius: 8
                        color: prevMa.containsMouse ? Qt.rgba(musicPanel.walForeground.r, musicPanel.walForeground.g, musicPanel.walForeground.b, 0.1) : "transparent"
                        Behavior on color { ColorAnimation { duration: 100 } }
                        Text { anchors.centerIn: parent; text: "󰒮"; color: musicPanel.walForeground; font.pixelSize: 20; font.family: "JetBrainsMono Nerd Font" }
                        MouseArea { id: prevMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { if (musicPanel.player && musicPanel.player.canGoPrevious) musicPanel.player.previous() } }
                    }

                    // Play/Pause
                    Rectangle {
                        width: 48; height: 48; radius: 24
                        color: musicPanel.walColor5
                        Text { anchors.centerIn: parent; text: musicPanel.isPlaying ? "󰏤" : "󰐊"; color: musicPanel.walBackground; font.pixelSize: 24; font.family: "JetBrainsMono Nerd Font" }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: { if (musicPanel.player && musicPanel.player.canTogglePlaying) musicPanel.player.togglePlaying() } }
                    }

                    // Next
                    Rectangle {
                        width: 36; height: 36; radius: 8
                        color: nextMa.containsMouse ? Qt.rgba(musicPanel.walForeground.r, musicPanel.walForeground.g, musicPanel.walForeground.b, 0.1) : "transparent"
                        Behavior on color { ColorAnimation { duration: 100 } }
                        Text { anchors.centerIn: parent; text: "󰒭"; color: musicPanel.walForeground; font.pixelSize: 20; font.family: "JetBrainsMono Nerd Font" }
                        MouseArea { id: nextMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { if (musicPanel.player && musicPanel.player.canGoNext) musicPanel.player.next() } }
                    }

                    // Repeat
                    Rectangle {
                        width: 32; height: 32; radius: 8; color: "transparent"
                        Text { anchors.centerIn: parent; text: "󰑖"; color: musicPanel.walForeground; font.pixelSize: 16; font.family: "JetBrainsMono Nerd Font" }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!musicPanel.player) return
                                if (musicPanel.player.loopStatus === MprisLoopStatus.None)
                                    musicPanel.player.loopStatus = MprisLoopStatus.Track
                                else if (musicPanel.player.loopStatus === MprisLoopStatus.Track)
                                    musicPanel.player.loopStatus = MprisLoopStatus.Playlist
                                else
                                    musicPanel.player.loopStatus = MprisLoopStatus.None
                            }
                        }
                    }
                }
            }
        }
    }
}
