import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#0c0c0c" // Запасной темный фон

    // Фоновое изображение (если задано в конфиге)
    Image {
        id: bgImage
        anchors.fill: parent
        source: config.background || ""
        fillMode: Image.PreserveAspectCrop
    }

    // Анимация тряски при неверном пароле
    SequentialAnimation {
        id: shakeAnim
        NumberAnimation { target: shakeTranslate; property: "x"; to: 12; duration: 40 }
        NumberAnimation { target: shakeTranslate; property: "x"; to: -12; duration: 40 }
        NumberAnimation { target: shakeTranslate; property: "x"; to: 8; duration: 40 }
        NumberAnimation { target: shakeTranslate; property: "x"; to: -8; duration: 40 }
        NumberAnimation { target: shakeTranslate; property: "x"; to: 4; duration: 40 }
        NumberAnimation { target: shakeTranslate; property: "x"; to: -4; duration: 40 }
        NumberAnimation { target: shakeTranslate; property: "x"; to: 0; duration: 40 }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            shakeTranslate.x = 0
            shakeAnim.start()
        }
    }

    // Центральная карточка входа (Монохромное матовое стекло)
    Rectangle {
        id: loginBox
        anchors.centerIn: parent
        width: 380
        height: 270
        color: "#26000000"           // 15% черная прозрачность
        border.color: "#1fffffff"    // Тонкая грань стекла (~12% белого)
        border.width: 1
        radius: 16

        // Применяем сдвиг через Translate напрямую
        transform: Translate {
            id: shakeTranslate
            x: 0
        }

        Column {
            anchors.centerIn: parent
            spacing: 16
            width: parent.width - 48

            // Заголовок
            Text {
                text: "вход"
                color: "#ffffff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 18
                font.weight: Font.Bold
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Поле ввода логина
            TextField {
                id: nameField
                width: parent.width
                height: 42
                text: userModel.lastUser
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                color: "#ffffff"
                placeholderText: "пользователь"
                placeholderTextColor: "#858585"
                
                background: Rectangle {
                    color: "#40000000"       // 25% черный фон инпута
                    border.color: "#1fffffff"
                    border.width: 1
                    radius: 10
                }
                
                Component.onCompleted: {
                    if (text === "") {
                        focus = true
                    } else {
                        passwordField.forceActiveFocus()
                    }
                }

                Keys.onReturnPressed: passwordField.forceActiveFocus()
            }

            // Поле ввода пароля
            TextField {
                id: passwordField
                width: parent.width
                height: 42
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                color: "#ffffff"
                echoMode: TextInput.Password
                placeholderText: "пароль"
                placeholderTextColor: "#858585"
                
                background: Rectangle {
                    color: "#40000000"
                    border.color: "#1fffffff"
                    border.width: 1
                    radius: 10
                }

                Keys.onReturnPressed: sddm.login(nameField.text, passwordField.text, 0)
            }

            // Кнопка входа
            Button {
                width: parent.width
                height: 40
                
                contentItem: Text {
                    text: "войти"
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.hovered ? "#28ffffff" : "#0affffff"
                    border.color: parent.hovered ? "#80ffffff" : "#1fffffff"
                    border.width: 1
                    radius: 10
                }

                onClicked: sddm.login(nameField.text, passwordField.text, 0)
            }
        }
    }

    // Кнопки питания и перезагрузки
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        spacing: 8

        Button {
            width: 38; height: 38
            contentItem: Text { text: "⏻"; color: "#ffffff"; font.family: "JetBrainsMono Nerd Font"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            background: Rectangle { color: "#26000000"; border.color: "#1fffffff"; radius: 10 }
            onClicked: sddm.powerOff()
        }
        Button {
            width: 38; height: 38
            contentItem: Text { text: "↻"; color: "#ffffff"; font.family: "JetBrainsMono Nerd Font"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            background: Rectangle { color: "#26000000"; border.color: "#1fffffff"; radius: 10 }
            onClicked: sddm.reboot()
        }
    }
}
