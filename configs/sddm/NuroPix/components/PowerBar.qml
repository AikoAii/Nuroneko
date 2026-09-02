/**
 * NuroPix - PowerBar Component
 * Copyright (c) 2026 Nur Aiko
 * Licensed under the MIT License.
 */
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: powerBarRoot

    property color textColor: typeof container !== "undefined" ? container.extractedAccent : "white"
    property color baseBgColor: typeof container !== "undefined" ? container.baseColor : "#202020"
    property color surfaceVarColor: typeof container !== "undefined" ? container.surfaceVariantColor : "#404040"
    property bool isReady: typeof container !== "undefined" ? container.uiReady : true

    height: 42
    width: barContent.implicitWidth + 32
    radius: 21

    color: baseBgColor
    opacity: isReady ? 0.72 : 0
    border.color: surfaceVarColor
    border.width: 1

    Behavior on opacity { NumberAnimation { duration: 200 } }

    FontLoader { id: iconFont; source: "../assets/fonts/MaterialDesignIcons.ttf" }

    RowLayout {
        id: barContent
        anchors.centerIn: parent
        spacing: 16

        // Battery Status
        Row {
            id: batteryRow
            spacing: 6
            visible: typeof battery !== "undefined" && typeof battery.percent !== "undefined"
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: batteryIcon
                text: (typeof battery !== "undefined" && battery.charging) ? "󱐋" : "󰁹"
                color: textColor
                font.pixelSize: 18
                font.family: iconFont.name
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: batteryText
                text: (typeof battery !== "undefined" ? battery.percent : "0") + "%"
                color: "white"
                font.pixelSize: 14
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }

            Timer {
                interval: 5000
                running: typeof battery !== "undefined" && battery.present
                repeat: true
                onTriggered: {
                    batteryText.text = battery.percent + "%"
                    batteryIcon.text = battery.charging ? "󱐋" : "󰁹"
                }
            }
        }

        // Keyboard Layout Toggle
        Item {
            visible: typeof keyboard !== "undefined" && keyboard.layouts.length > 1
            implicitWidth: layoutText.implicitWidth + 12
            implicitHeight: 28
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: 14
                color: layoutArea.pressed ? Qt.rgba(1,1,1,0.2) : (layoutArea.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent")
            }

            Text {
                id: layoutText
                anchors.centerIn: parent
                text: (typeof keyboard !== "undefined" && keyboard.layouts[keyboard.currentLayout]) ? keyboard.layouts[keyboard.currentLayout].shortName : "US"
                color: "white"
                font.pixelSize: 13
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
            }

            MouseArea {
                id: layoutArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    keyboard.currentLayout = (keyboard.currentLayout + 1) % keyboard.layouts.length
                }
            }
        }

        // Suspend Button
        Item {
            implicitWidth: 28
            implicitHeight: 28
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: 14
                color: suspendArea.pressed ? Qt.rgba(1,0.8,0,0.3) : (suspendArea.containsMouse ? Qt.rgba(1,0.8,0,0.2) : "transparent")
            }

            Text {
                anchors.centerIn: parent
                text: "󰤄"
                color: suspendArea.containsMouse ? "#FFAB00" : "white"
                font.pixelSize: 18
                font.family: iconFont.name
                scale: suspendArea.containsMouse ? 1.15 : 1.0
                Behavior on scale { NumberAnimation { duration: 150 } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            MouseArea {
                id: suspendArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.suspend()
            }
        }

        // Restart Button
        Item {
            implicitWidth: 28
            implicitHeight: 28
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: 14
                color: restartArea.pressed ? Qt.rgba(0.2,0.5,1,0.3) : (restartArea.containsMouse ? Qt.rgba(0.2,0.5,1,0.2) : "transparent")
            }

            Text {
                anchors.centerIn: parent
                text: "󰑐"
                color: restartArea.containsMouse ? "#448AFF" : "white"
                font.pixelSize: 18
                font.family: iconFont.name
                scale: restartArea.containsMouse ? 1.15 : 1.0
                Behavior on scale { NumberAnimation { duration: 150 } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            MouseArea {
                id: restartArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.reboot()
            }
        }

        // Shutdown Button
        Item {
            implicitWidth: 28
            implicitHeight: 28
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: 14
                color: powerArea.pressed ? Qt.rgba(1,0.2,0.2,0.3) : (powerArea.containsMouse ? Qt.rgba(1,0.2,0.2,0.2) : "transparent")
            }

            Text {
                anchors.centerIn: parent
                text: "󰐥"
                color: powerArea.containsMouse ? "#FF4444" : "white"
                font.pixelSize: 18
                font.family: iconFont.name
                scale: powerArea.containsMouse ? 1.15 : 1.0
                Behavior on scale { NumberAnimation { duration: 150 } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            MouseArea {
                id: powerArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.powerOff()
            }
        }
    }
}
