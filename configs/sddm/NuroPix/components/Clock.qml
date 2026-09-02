/*
 * NuroPix - Clock.qml
 * Copyright (c) 2026 Nur Aiko
 * Licensed under the MIT License.
 */
import QtQuick
import QtQuick.Layouts

Item {
    id: clock

    property string backgroundSource: ""
    property color defaultHoursColor: "#AED68A"
    property color defaultMinutesColor: "#D4E4BC"
    property string fontFamily: "FlexRounded"
    property color baseAccent: config.accentColor

    property color smartHoursColor: defaultHoursColor
    property color smartMinutesColor: defaultMinutesColor

    property string timeStr: "0000"

    implicitWidth: clockContainer.width
    implicitHeight: clockContainer.height

    function updateTime() {
        var date = new Date()
        var hours = date.getHours()
        var minutes = date.getMinutes()

        if (config.use24HourClock !== "true") {
            hours = hours % 12
            if (hours === 0)
                hours = 12
        }

        var hStr = hours < 10 ? "0" + hours : "" + hours
        var mStr = minutes < 10 ? "0" + minutes : "" + minutes

        timeStr = hStr + mStr
    }

    function updateColors() {
        var base = baseAccent

        if (base.hsvSaturation < 0.15) {
            smartHoursColor = Qt.lighter(base, 1.3)
            smartMinutesColor = Qt.darker(base, 1.4)
            return
        }

        if (base.hsvValue < 0.5) {
            smartHoursColor = Qt.hsva(base.hsvHue, 0.75, 0.95, 1)
            smartMinutesColor = Qt.hsva(base.hsvHue, 0.45, 0.88, 1)
        } else if (base.hsvValue > 0.8 && base.hsvSaturation < 0.2) {
            smartHoursColor = Qt.hsva(base.hsvHue, 0.85, 0.75, 1)
            smartMinutesColor = Qt.hsva(base.hsvHue, 0.5, 0.8, 1)
        } else {
            smartHoursColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 1.35), 0.98, 1)
            smartMinutesColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 0.70), 0.90, 1)
        }
    }

    onBaseAccentChanged: updateColors()

    Component.onCompleted: {
        updateColors()
        updateTime()
    }

   Rectangle {
        id: clockContainer
        anchors.centerIn: parent

        width: 380
        height: 480
        radius: 36
        color: typeof container !== "undefined" ? container.baseColor : "#202020"
        opacity: 0.72

        border.color: typeof container !== "undefined" ? container.surfaceVariantColor : "#404040"
        border.width: 1

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "white"
            opacity: 0.03
        }
        
        // ... sisa kodingan Clock.qml sama ...
        RowLayout {
            anchors.centerIn: parent
            spacing: -6

            ColumnLayout {
                spacing: -68

                Text {
                    text: clock.timeStr.length >= 1 ? clock.timeStr.charAt(0) : "0"
                    color: clock.smartHoursColor
                    font.family: clock.fontFamily
                    font.pixelSize: 172
                    font.weight: Font.Bold
                    Layout.preferredWidth: 135
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    antialiasing: true
                }

                Text {
                    text: clock.timeStr.length >= 3 ? clock.timeStr.charAt(2) : "0"
                    color: clock.smartMinutesColor
                    font.family: clock.fontFamily
                    font.pixelSize: 172
                    font.weight: Font.Bold
                    Layout.preferredWidth: 135
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    antialiasing: true
                }
            }

            ColumnLayout {
                spacing: -68

                Text {
                    text: clock.timeStr.length >= 2 ? clock.timeStr.charAt(1) : "0"
                    color: clock.smartHoursColor
                    font.family: clock.fontFamily
                    font.pixelSize: 172
                    font.weight: Font.Bold
                    Layout.preferredWidth: 135
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    antialiasing: true
                }

                Text {
                    text: clock.timeStr.length >= 4 ? clock.timeStr.charAt(3) : "0"
                    color: clock.smartMinutesColor
                    font.family: clock.fontFamily
                    font.pixelSize: 172
                    font.weight: Font.Bold
                    Layout.preferredWidth: 135
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    antialiasing: true
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }
}
