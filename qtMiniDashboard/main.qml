import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0

ApplicationWindow  {
    id: main
    visible: true
    width: Screen.width * 0.8
    height: Screen.height * 0.8
    title: qsTr("Hello World")

    property date currentDateTime: new Date()

    Timer
    {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered:
        {
            currentDateTime = new Date()
        }
    }

    background: Rectangle
    {
        gradient: Gradient
        {
            GradientStop{
                position: 0.0
                color: "#c9d6ff"
            }

            GradientStop
            {
                position: 0.1
                color: "#e2e2e2"
            }
        }
    }

    Rectangle {
        id: headerBackground

        gradient: Gradient
        {
            GradientStop{
                position: 0.0
                color: "#56CCF2"
            }

            GradientStop
            {
                position: 1.0
                color: "#2F80ED"
            }
        }

        height: 70
        radius: 0

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout {
            id: headerLayout

            anchors {
                fill: parent

                leftMargin: 30
                rightMargin: 30
            }

            spacing: 10

            Text {
                id: timeText

                text: Qt.formatDateTime(
                          main.currentDateTime,
                          "yyyy/MM/dd  HH:mm:ss"
                      )

                color: "white"
                font.pixelSize: 20

                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                id: dayNameText

                text: Qt.formatDateTime(
                          main.currentDateTime,
                          "dddd"
                      )

                color: "white"
                font.pixelSize: 20

                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
