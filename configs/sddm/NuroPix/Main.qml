/*
 * NuroPix SDDM Theme - Main.qml
 * Author : Annur Musthofa (Aiko)
 * License: MIT License
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "components"

Rectangle {
    id: container
    width: 1920
    height: 1080
    color: config.backgroundColor
    focus: !loginState.visible

    property int userIndex: 0
    property int sessionIndex: 0
    property bool isLoggingIn: false
    property bool showPassword: false
    property int lastSplashIndex: -1

    property var arisuQuotes: [
        "Panpakapan~!",
        "Okaerinasai, Sensei!",
        "Arisu, Login shimashita!",
        "Quest Start!",
        "Arisu wa Level UP!",
        "Save Point reached!",
        "Hikari yo!",
        "Arisu no HP wa mantan!",
        "Quest Cleared!"
    ]

    property color extractedAccent: config.accentColor
    property color baseColor: config.backgroundColor
    property color surfaceColor: Qt.lighter(baseColor, 1.3)
    property color surfaceVariantColor: Qt.lighter(baseColor, 1.6)
    property bool uiReady: config.autoColor !== "true" || colorExtractor.processed

    Component.onCompleted: {
        if (typeof userModel !== "undefined" && userModel.lastIndex >= 0) userIndex = userModel.lastIndex;
        if (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) sessionIndex = sessionModel.lastIndex;
    }

    function getRandomArisuQuote() {
        if (arisuQuotes.length <= 1) return arisuQuotes[0];
        var idx = Math.floor(Math.random() * arisuQuotes.length);
        while (idx === lastSplashIndex) {
            idx = Math.floor(Math.random() * arisuQuotes.length);
        }
        lastSplashIndex = idx;
        return arisuQuotes[idx];
    }

    property string splashText: config.splashText && config.splashText !== "" ? config.splashText : getRandomArisuQuote()

    function cleanName(name) {
        if (!name) return "";
        var s = name.toString();
        if (s.endsWith("/")) s = s.substring(0, s.length - 1);
        if (s.indexOf("/") !== -1) s = s.substring(s.lastIndexOf("/") + 1);
        if (s.indexOf(".desktop") !== -1) s = s.substring(0, s.indexOf(".desktop"));
        s = s.replace(/[-_]/g, ' ');
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

    function getSelectedSessionName() {
        if (typeof sessionModel !== "undefined" && sessionModel.count > 0) {
            var idx = container.sessionIndex;
            if (idx < 0 || idx >= sessionModel.count) idx = 0;
            var modelIdx = sessionModel.index(idx, 0);
            var n = sessionModel.data(modelIdx, Qt.UserRole + 4);
            var f = sessionModel.data(modelIdx, Qt.UserRole + 2);
            var d = sessionModel.data(modelIdx, Qt.DisplayRole);
            var finalName = n ? n.toString() : (f ? f.toString() : (d ? d.toString() : "Desktop"));
            return cleanName(finalName);
        }
        return "Desktop";
    }

    function getOSName() {
        if (typeof config !== "undefined" && config.osName && config.osName !== "") return config.osName;
        if (typeof sddm !== "undefined" && sddm.hostName && sddm.hostName !== "") return sddm.hostName;
        return "Linux";
    }

    function doLogin() {
        if (!loginState.visible || isLoggingIn) return;

        var user = "";
        if (typeof userModel !== "undefined" && userModel.count > 0) {
            var idx = container.userIndex;
            if (idx < 0 || idx >= userModel.count) idx = 0;
            var edit = userModel.data(userModel.index(idx, 0), Qt.EditRole);
            var nameRole = userModel.data(userModel.index(idx, 0), Qt.UserRole + 1);
            var display = userModel.data(userModel.index(idx, 0), Qt.DisplayRole);
            user = edit ? edit.toString() : (nameRole ? nameRole.toString() : (display ? display.toString() : ""));
        }

        if (!user || user === "" || user === "User") user = sddm.lastUser;
        if (!user && typeof userModel !== "undefined" && userModel.count > 0) {
            var firstEdit = userModel.data(userModel.index(0, 0), Qt.EditRole);
            user = firstEdit ? firstEdit.toString() : "";
        }

        if (!user) return;

        container.isLoggingIn = true;
        var pass = passwordField.text;
        var sess = container.sessionIndex;
        if (typeof sessionModel !== "undefined") {
            if (sess < 0 || sess >= sessionModel.count) sess = 0;
        } else {
            sess = 0;
        }

        sddm.login(user.trim(), pass, sess);
        loginTimeout.start();
    }

    Timer {
        id: loginTimeout
        interval: 5000
        onTriggered: container.isLoggingIn = false
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            container.isLoggingIn = false
            container.showPassword = false
            loginTimeout.stop()
            loginState.isError = true
            shakeAnimation.start()
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
        function onLoginSucceeded() {
            loginTimeout.stop()
        }
    }

    Timer {
        id: colorDelay
        interval: 1000
        repeat: true
        running: backgroundImage.status === Image.Ready && !colorExtractor.processed && config.autoColor === "true"
        onTriggered: colorExtractor.requestPaint()
    }

    Canvas {
        id: colorExtractor
        width: 60; height: 60
        x: -100; y: -100
        z: -1
        renderTarget: Canvas.Image
        property bool processed: false
        property int retries: 0

        onPaint: {
            var ctx = getContext("2d");
            var res = 60;
            ctx.clearRect(0, 0, res, res);
            ctx.drawImage(backgroundImage, 0, 0, res, res);
            var imgData = ctx.getImageData(0, 0, res, res).data;
            if (!imgData || imgData.length === 0) return;

            var histogram = new Array(36).fill(0);
            var sampleColors = new Array(36).fill(null);
            var vibrantFound = false;
            var pixelSum = 0;

            for (var p = 0; p < imgData.length; p++) pixelSum += imgData[p];
            if (pixelSum === 0) {
                retries++;
                if (retries > 3) {
                    container.extractedAccent = "#D0D0D0";
                    processed = true;
                }
                return;
            }

            retries = 0;
            for (var i = 0; i < imgData.length; i += 4) {
                var r = imgData[i] / 255;
                var g = imgData[i+1] / 255;
                var b = imgData[i+2] / 255;
                var pCol = Qt.rgba(r, g, b, 1.0);

                if (pCol.hsvSaturation > 0.3 && pCol.hsvValue > 0.15) {
                    var h = pCol.hsvHue * 360;
                    if (h < 0) continue;
                    var bIdx = Math.floor(h / 10) % 36;
                    var weight = pCol.hsvSaturation * pCol.hsvValue;
                    histogram[bIdx] += weight;

                    if (!sampleColors[bIdx] || weight > (sampleColors[bIdx].hsvSaturation * sampleColors[bIdx].hsvValue)) {
                        sampleColors[bIdx] = pCol;
                    }
                    vibrantFound = true;
                }
            }

            if (!vibrantFound) {
                container.extractedAccent = "#404040";
                processed = true;
                return;
            }

            histogram[0] += histogram[35];
            var maxCount = -1;
            var winnerIdx = -1;
            for (var j = 0; j < 35; j++) {
                if (histogram[j] > maxCount) {
                    maxCount = histogram[j];
                    winnerIdx = j;
                }
            }

            if (winnerIdx !== -1 && sampleColors[winnerIdx]) {
                var finalColor = sampleColors[winnerIdx];
                container.extractedAccent = Qt.hsva(finalColor.hsvHue, Math.max(0.35, Math.min(0.55, finalColor.hsvSaturation * 0.9)), 0.95, 1.0);
                processed = true;
            }
        }
    }

    Connections {
        target: backgroundImage
        function onStatusChanged() {
            if (backgroundImage.status === Image.Ready) {
                colorExtractor.processed = false;
                colorDelay.start();
            }
        }
    }

    FontLoader { id: fontRegular; source: "assets/fonts/FlexRounded-R.ttf" }
    FontLoader { id: fontMedium; source: "assets/fonts/FlexRounded-M.ttf" }
    FontLoader { id: fontBold; source: "assets/fonts/FlexRounded-B.ttf" }
    FontLoader { id: iconFont; source: "assets/fonts/MaterialDesignIcons.ttf" }

    Image {
        id: backgroundImage
        source: config.background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    MultiEffect {
        id: backgroundBlur
        anchors.fill: parent
        source: backgroundImage
        blurEnabled: true
        blur: loginState.visible ? 1.0 : 0.0
        opacity: loginState.visible ? 1.0 : 0.0
        autoPaddingEnabled: false

        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }
        Behavior on blur { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: loginState.visible ? 0.6 : 0.4
        Behavior on opacity { NumberAnimation { duration: 400 } }
    }

    PowerBar {
        anchors { top: parent.top; right: parent.right; topMargin: 30; rightMargin: 40 }
        textColor: container.extractedAccent
        z: 100
        opacity: container.uiReady ? 0.72 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Shortcut {
        sequence: "Escape"
        enabled: loginState.visible
        onActivated: {
            loginState.visible = false;
            loginState.isError = false;
            container.showPassword = false;
            passwordField.text = "";
            container.focus = true;
        }
    }

    Shortcut {
        sequences: ["Return", "Enter"]
        enabled: loginState.visible
        onActivated: container.doLogin()
    }

    Rectangle {
        id: datePill
        height: 42
        width: dateRow.implicitWidth + 32
        radius: 21
        color: container.baseColor
        opacity: container.uiReady ? 0.72 : 0
        border.color: container.surfaceVariantColor
        border.width: 1

        anchors { top: parent.top; left: parent.left; topMargin: 30; leftMargin: 40 }

        RowLayout {
            id: dateRow
            anchors.centerIn: parent
            spacing: 10
            Text { text: "󰸗"; color: container.extractedAccent; font.pixelSize: 18; font.family: iconFont.name }
            Text { text: Qt.formatDateTime(new Date(), "dddd, MMMM d"); color: container.extractedAccent; font.pixelSize: 14; font.weight: Font.Medium; font.family: fontRegular.name }
        }
    }

    Rectangle {
        id: sysPill
        height: 42
        width: sysRow.implicitWidth + 32
        radius: 21
        color: container.baseColor
        opacity: container.uiReady ? 0.72 : 0
        border.color: container.surfaceVariantColor
        border.width: 1

        anchors { bottom: parent.bottom; left: parent.left; bottomMargin: 30; leftMargin: 40 }

        RowLayout {
            id: sysRow
            anchors.centerIn: parent
            spacing: 10
            Text { text: "󰌢"; color: container.extractedAccent; font.pixelSize: 18; font.family: iconFont.name }
            Text { text: container.getOSName() + " • " + container.getSelectedSessionName(); color: container.extractedAccent; font.pixelSize: 14; font.weight: Font.Medium; font.family: fontRegular.name }
        }
    }

    Rectangle {
        id: lockWarningPill
        height: 42
        width: warningRow.implicitWidth + 32
        radius: 21
        color: container.baseColor
        opacity: (container.uiReady && (numLockActive || capsLockActive)) ? 0.72 : 0
        border.color: container.surfaceVariantColor
        border.width: 1

        property bool numLockActive: typeof keyboard !== "undefined" && typeof keyboard.numLock !== "undefined" ? keyboard.numLock : false
        property bool capsLockActive: typeof keyboard !== "undefined" && typeof keyboard.capsLock !== "undefined" ? keyboard.capsLock : false

        anchors { bottom: parent.bottom; right: parent.right; bottomMargin: 30; rightMargin: 40 }

        RowLayout {
            id: warningRow
            anchors.centerIn: parent
            spacing: 8
            Text { text: "󰌌"; color: container.extractedAccent; font.pixelSize: 18; font.family: iconFont.name }
            Text {
                text: {
                    var msgs = [];
                    if (lockWarningPill.capsLockActive) msgs.push("Caps Lock ON");
                    if (lockWarningPill.numLockActive) msgs.push("Num Lock ON");
                    return msgs.join(" | ");
                }
                color: container.extractedAccent
                font.pixelSize: 13
                font.weight: Font.Medium
                font.family: fontRegular.name
            }
        }
    }

    Item {
        id: lockState
        anchors.fill: parent
        visible: !loginState.visible
        opacity: visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 400 } }

        Clock {
            id: mainClock
            anchors.centerIn: parent
            backgroundSource: config.background
            baseAccent: container.extractedAccent
            fontFamily: fontRegular.name
            opacity: container.uiReady ? 1 : 0
        }

        Text {
            text: "Press any key to unlock"
            color: config.textColor
            font.pixelSize: 16
            anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 100 }
            opacity: 0.5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                loginState.visible = true;
                passwordField.forceActiveFocus();
            }
        }
    }

    Item {
        id: loginState
        anchors.fill: parent
        visible: false
        opacity: visible ? 1 : 0
        z: 10
        Behavior on opacity { NumberAnimation { duration: 400 } }

        onVisibleChanged: {
            if (visible) passwordField.forceActiveFocus();
        }

        property bool isError: false
        SequentialAnimation {
            id: shakeAnimation
            loops: 2
            PropertyAnimation { target: loginCard; property: "x"; from: (container.width - loginCard.width)/2; to: (container.width - loginCard.width)/2 - 10; duration: 50; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: loginCard; property: "x"; from: (container.width - loginCard.width)/2 - 10; to: (container.width - loginCard.width)/2 + 10; duration: 50; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: loginCard; property: "x"; from: (container.width - loginCard.width)/2 + 10; to: (container.width - loginCard.width)/2; duration: 50; easing.type: Easing.InOutQuad }
            onStopped: isError = false
        }

        Rectangle {
            id: loginCard
            width: 360
            height: 420
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            color: loginState.isError ? "#442222" : baseColor
            opacity: 0.72
            radius: 36
            border.color: container.surfaceVariantColor
            border.width: 1

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "white"
                opacity: 0.03
            }

            Behavior on color { ColorAnimation { duration: 200 } }

            Rectangle {
                id: speechBubble
                z: 20
                color: speechMouseArea.containsMouse ? container.surfaceVariantColor : container.surfaceColor
                radius: 20
                border.color: Qt.rgba(container.extractedAccent.r, container.extractedAccent.g, container.extractedAccent.b, 0.4)
                border.width: 1
                width: bubbleText.implicitWidth + 40
                height: 36

                Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
                Behavior on color { ColorAnimation { duration: 150 } }

                anchors { top: parent.top; topMargin: 24; left: parent.left; leftMargin: 226 }

                Canvas {
                    id: bubbleTail
                    width: 10
                    height: 12
                    x: -8
                    y: (parent.height - height) / 2
                    property color fillColor: speechBubble.color
                    property color strokeColor: speechBubble.border.color

                    onFillColorChanged: requestPaint()
                    onStrokeColorChanged: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        ctx.beginPath();
                        ctx.moveTo(width, 0);
                        ctx.lineTo(0, height / 2);
                        ctx.lineTo(width, height);
                        ctx.closePath();
                        ctx.fillStyle = fillColor;
                        ctx.fill();
                        ctx.strokeStyle = strokeColor;
                        ctx.lineWidth = 1;
                        ctx.stroke();
                    }
                }

                Rectangle {
                    width: 4
                    height: bubbleTail.height + 2
                    x: 0
                    y: bubbleTail.y - 1
                    color: speechBubble.color
                    z: 1
                }

                Text {
                    id: bubbleText
                    anchors.centerIn: parent
                    text: container.splashText
                    color: "white"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    font.family: fontRegular.name
                }

                MouseArea {
                    id: speechMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: container.splashText = container.getRandomArisuQuote()
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 28
                anchors.bottomMargin: 28
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 10

                Item {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 100
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "transparent"
                        border.color: container.extractedAccent
                        border.width: 2
                        opacity: 0.8
                    }

                    Rectangle {
                        id: avatarFallback
                        anchors.fill: parent
                        anchors.margins: 4
                        color: surfaceColor
                        radius: width / 2
                        visible: avatar.status !== Image.Ready

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var n = "";
                                if (typeof userModel !== "undefined" && userModel.count > 0) {
                                    var d = userModel.data(userModel.index(container.userIndex, 0), Qt.DisplayRole);
                                    var nr = userModel.data(userModel.index(container.userIndex, 0), Qt.UserRole + 1);
                                    n = d ? d.toString() : (nr ? nr.toString() : "U");
                                } else {
                                    n = sddm.lastUser ? sddm.lastUser : "U";
                                }
                                return n.charAt(0).toUpperCase();
                            }
                            color: container.extractedAccent
                            font.pixelSize: 40
                            font.family: fontBold.name
                            font.weight: Font.Bold
                        }
                    }

                    Canvas {
                        id: avatarCanvas
                        anchors.fill: parent
                        anchors.margins: 4
                        visible: avatar.status === Image.Ready

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();
                            ctx.beginPath();
                            ctx.arc(width/2, height/2, width/2, 0, 2 * Math.PI);
                            ctx.closePath();
                            ctx.clip();
                            ctx.drawImage(avatar, 0, 0, width, height);
                        }

                        Timer {
                            id: repaintTimer
                            interval: 500
                            onTriggered: avatarCanvas.requestPaint()
                        }

                        Image {
                            id: avatar
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            visible: false

                            Component.onCompleted: {
                                var s = Qt.resolvedUrl("assets/avatar.jpg");
                                if (typeof userModel !== "undefined" && userModel.count > 0) {
                                    var icon = userModel.data(userModel.index(container.userIndex, 0), Qt.UserRole + 3);
                                    if (icon && icon.toString().match(/\.(jpg|jpeg|png|bmp|webp|svg)$/i)) {
                                        s = icon.toString();
                                    }
                                }
                                source = s;
                            }

                            onStatusChanged: {
                                if (status === Image.Ready) repaintTimer.start();
                            }
                        }
                    }
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: userNameLabel.width + 24
                    Layout.preferredHeight: userNameLabel.height + 8

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: userClickArea.pressed ? 0.15 : 0
                        radius: 10
                        Behavior on opacity { NumberAnimation { duration: 100 } }
                    }

                    Text {
                        id: userNameLabel
                        anchors.centerIn: parent
                        text: {
                            if (typeof userModel !== "undefined" && userModel.count > 0) {
                                var idx = container.userIndex;
                                var modelIdx = userModel.index(idx, 0);
                                var display = userModel.data(modelIdx, Qt.DisplayRole);
                                var edit = userModel.data(modelIdx, Qt.EditRole);
                                var nr = userModel.data(modelIdx, Qt.UserRole + 1);
                                var realName = userModel.data(modelIdx, Qt.UserRole + 2);
                                var finalName = display ? display.toString() : (realName ? realName.toString() : (nr ? nr.toString() : (edit ? edit.toString() : "User")));
                                return cleanName(finalName) + (userModel.count > 1 ? " ▾" : "");
                            }
                            return cleanName(sddm.lastUser ? sddm.lastUser : "User");
                        }
                        color: "white"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        font.family: fontRegular.name
                    }

                    MouseArea {
                        id: userClickArea
                        anchors.fill: parent
                        onClicked: userPopup.open()
                    }
                }

                Rectangle {
                    id: sessionPill
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 32
                    color: (sessionClickArea.pressed || sessionPopup.opened) ? surfaceVariantColor : surfaceColor
                    radius: 16
                    border.width: 1
                    border.color: (sessionClickArea.pressed || sessionPopup.opened) ? container.extractedAccent : surfaceVariantColor

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "󰟀"; color: container.extractedAccent; font.pixelSize: 14; font.family: iconFont.name }
                        Text { text: container.getSelectedSessionName() + (typeof sessionModel !== "undefined" && sessionModel.count > 1 ? " ▾" : ""); color: "white"; font.pixelSize: 12; font.weight: Font.Medium }
                    }

                    MouseArea {
                        id: sessionClickArea
                        anchors.fill: parent
                        onClicked: sessionPopup.open()
                    }
                }

                TextField {
                    id: passwordField
                    Layout.topMargin: 8
                    Layout.preferredWidth: 280
                    Layout.preferredHeight: 44
                    Layout.alignment: Qt.AlignHCenter
                    echoMode: container.showPassword ? TextInput.Normal : TextInput.Password
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 14
                    color: "white"
                    focus: loginState.visible
                    enabled: !container.isLoggingIn
                    leftPadding: 40
                    rightPadding: 40

                    background: Rectangle {
                        color: surfaceColor
                        radius: 22
                        border.width: parent.activeFocus ? 1.5 : 0
                        border.color: container.extractedAccent
                        opacity: parent.enabled ? 1.0 : 0.5
                    }

                    Text {
                        anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                        text: "󰌾"
                        color: passwordField.activeFocus ? container.extractedAccent : "gray"
                        font.pixelSize: 16
                        font.family: iconFont.name
                        opacity: 0.7
                    }

                    Text {
                        text: "Enter Password"
                        color: "gray"
                        font.pixelSize: 13
                        visible: !parent.text
                        anchors.centerIn: parent
                        opacity: 0.4
                    }

                    Text {
                        anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
                        text: container.showPassword ? "󰈈" : "󰈉"
                        color: toggleEyeArea.containsMouse ? container.extractedAccent : "gray"
                        font.pixelSize: 16
                        font.family: iconFont.name
                        visible: passwordField.text.length > 0

                        MouseArea {
                            id: toggleEyeArea
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            onClicked: {
                                container.showPassword = !container.showPassword;
                                passwordField.forceActiveFocus();
                            }
                        }
                    }

                    onAccepted: container.doLogin()
                }

                RoundButton {
                    id: loginButton
                    Layout.topMargin: 6
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 52
                    Layout.preferredHeight: 52
                    focusPolicy: Qt.NoFocus
                    enabled: !container.isLoggingIn

                    contentItem: Text {
                        text: container.isLoggingIn ? "⋯" : "→"
                        color: "white"
                        font.pixelSize: 26
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: container.isLoggingIn ? surfaceVariantColor : (loginButton.pressed ? Qt.darker(container.extractedAccent, 1.1) : container.extractedAccent)
                        radius: 26
                        opacity: container.isLoggingIn ? 0.5 : 1.0
                    }

                    onClicked: container.doLogin()
                }
            }
        }
    }

    Keys.onPressed: function(event) {
        if (!loginState.visible) {
            loginState.visible = true;
            passwordField.forceActiveFocus();
            event.accepted = true;
        }
    }

    Popup {
        id: userPopup
        width: 260
        height: (typeof userModel !== "undefined") ? Math.min(300, userModel.count * 50 + 20) : 100
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2 - 50
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onOpened: userList.forceActiveFocus()
        background: Rectangle { color: baseColor; radius: 24; opacity: 0.95; border.color: surfaceVariantColor; border.width: 1 }

        ListView {
            id: userList
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof userModel !== "undefined") ? userModel : null
            spacing: 5
            clip: true
            focus: true
            currentIndex: container.userIndex
            highlightFollowsCurrentItem: true

            delegate: ItemDelegate {
                width: parent.width
                height: 40
                property bool isCurrent: index === userList.currentIndex
                background: Rectangle {
                    color: isCurrent ? surfaceVariantColor : (hovered ? surfaceColor : "transparent")
                    radius: 12
                    Rectangle {
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; anchors.leftMargin: 8
                        width: 4; height: isCurrent ? 16 : 0
                        color: container.extractedAccent
                        radius: 2
                        Behavior on height { NumberAnimation { duration: 150 } }
                    }
                }
                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    Item { Layout.preferredWidth: 20 }
                    Rectangle {
                        Layout.preferredWidth: 28; Layout.preferredHeight: 28; Layout.alignment: Qt.AlignVCenter
                        color: isCurrent ? container.extractedAccent : surfaceVariantColor
                        radius: 14
                        Text {
                            anchors.centerIn: parent
                            text: {
                                var mIdx = userModel.index(index, 0);
                                var d = userModel.data(mIdx, Qt.DisplayRole);
                                var n_r = userModel.data(mIdx, Qt.UserRole + 1);
                                var finalVal = d ? d.toString() : (n_r ? n_r.toString() : "U");
                                return finalVal.charAt(0).toUpperCase();
                            }
                            color: isCurrent ? baseColor : "white"
                            font.pixelSize: 12
                            font.family: fontBold.name
                            font.weight: Font.Bold
                        }
                    }
                    Item { Layout.preferredWidth: 12 }
                    Text {
                        Layout.fillWidth: true
                        text: {
                            var mIdx = userModel.index(index, 0);
                            var d = userModel.data(mIdx, Qt.DisplayRole);
                            var n_r = userModel.data(mIdx, Qt.UserRole + 1);
                            var r = userModel.data(mIdx, Qt.UserRole + 2);
                            var e = userModel.data(mIdx, Qt.EditRole);
                            return cleanName(d ? d : (r ? r : (n_r ? n_r : e)));
                        }
                        color: isCurrent ? "white" : (hovered ? "#DDDDDD" : "#AAAAAA")
                        font.pixelSize: 15
                        font.family: fontRegular.name
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        rightPadding: 60
                        elide: Text.ElideRight
                    }
                }
                onClicked: {
                    container.userIndex = index;
                    userPopup.close();
                }
            }
            Keys.onDownPressed: incrementCurrentIndex()
            Keys.onUpPressed: decrementCurrentIndex()
            Keys.onReturnPressed: { container.userIndex = currentIndex; userPopup.close(); }
            Keys.onEnterPressed: { container.userIndex = currentIndex; userPopup.close(); }
        }
    }

    Popup {
        id: sessionPopup
        width: 260
        height: (typeof sessionModel !== "undefined") ? Math.min(250, sessionModel.count * 50 + 20) : 100
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2 + 80
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onOpened: sessionList.forceActiveFocus()
        background: Rectangle { color: baseColor; radius: 24; opacity: 0.95; border.color: surfaceVariantColor; border.width: 1 }

        ListView {
            id: sessionList
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof sessionModel !== "undefined") ? sessionModel : null
            spacing: 5
            clip: true
            focus: true
            currentIndex: container.sessionIndex
            highlightFollowsCurrentItem: true

            delegate: ItemDelegate {
                width: parent.width
                height: 40
                property bool isCurrent: index === sessionList.currentIndex
                background: Rectangle {
                    color: isCurrent ? surfaceVariantColor : (hovered ? surfaceColor : "transparent")
                    radius: 12
                    Rectangle {
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; anchors.leftMargin: 8
                        width: 4; height: isCurrent ? 16 : 0
                        color: container.extractedAccent
                        radius: 2
                        Behavior on height { NumberAnimation { duration: 150 } }
                    }
                }
                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    Item { Layout.preferredWidth: 20 }
                    Text {
                        Layout.preferredWidth: 40
                        text: "󰟀"
                        color: isCurrent ? container.extractedAccent : "gray"
                        font.pixelSize: 16
                        font.family: iconFont.name
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        Layout.fillWidth: true
                        text: {
                            var n_val = sessionModel.data(sessionModel.index(index, 0), Qt.UserRole + 4);
                            var f_val = sessionModel.data(sessionModel.index(index, 0), Qt.UserRole + 2);
                            return cleanName(n_val ? n_val : f_val);
                        }
                        color: isCurrent ? "white" : "#AAAAAA"
                        font.pixelSize: 14
                        font.family: fontRegular.name
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        rightPadding: 60
                        elide: Text.ElideRight
                    }
                }
                onClicked: {
                    container.sessionIndex = index;
                    sessionPopup.close();
                }
            }
            Keys.onDownPressed: incrementCurrentIndex()
            Keys.onUpPressed: decrementCurrentIndex()
            Keys.onReturnPressed: { container.sessionIndex = currentIndex; sessionPopup.close(); }
            Keys.onEnterPressed: { container.sessionIndex = currentIndex; sessionPopup.close(); }
        }
    }
}