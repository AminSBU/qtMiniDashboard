import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import "pages"

ApplicationWindow  {
    id: main
    visible: true
    width: Screen.width * 0.8
    height: Screen.height * 0.8
    title: qsTr("Hello World")

    property date currentDateTime: new Date()
    property int currentPageIndex: 0

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

    // header
    Rectangle {
        id: headerBackground

        gradient: Gradient
        {
            GradientStop {
                position: 0.0
                color: "#29323c"
            }

            GradientStop {
                position: 1.0
                color: "#485563"
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
                font.bold: true
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
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // main
    StackLayout {
        id: pagesLayout

        HomePage{}

//        anchors {
//            top: headerBackground.bottom
//            bottom: footerBackground.top
//            left: parent.left
//            right: parent.right
//        }

//        currentIndex: main.currentPageIndex

//        Page {
//            background: Rectangle {
//                color: "transparent"
//            }

//            Text {
//                anchors.centerIn: parent
//                text: "صفحه اصلی"
//                color: "#2F80ED"
//                font.pixelSize: 32
//                font.bold: true
//            }
//        }

//        Page {
//            background: Rectangle {
//                color: "transparent"
//            }

//            Text {
//                anchors.centerIn: parent
//                text: "مدیریت شارژرها"
//                color: "#2F80ED"
//                font.pixelSize: 32
//                font.bold: true
//            }
//        }

//        Page {
//            background: Rectangle {
//                color: "transparent"
//            }

//            Text {
//                anchors.centerIn: parent
//                text: "گزارش‌ها"
//                color: "#2F80ED"
//                font.pixelSize: 32
//                font.bold: true
//            }
//        }

//        Page {
//            background: Rectangle {
//                color: "transparent"
//            }

//            Text {
//                anchors.centerIn: parent
//                text: "تنظیمات"
//                color: "#2F80ED"
//                font.pixelSize: 32
//                font.bold: true
//            }
//        }

//        Page {
//            background: Rectangle {
//                color: "transparent"
//            }

//            Text {
//                anchors.centerIn: parent
//                text: "درباره ما"
//                color: "#2F80ED"
//                font.pixelSize: 32
//                font.bold: true
//            }
//        }
    }

    //footer
    Rectangle {
        id: footerBackground

        height: 70
        radius: 0

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#29323c"
            }

            GradientStop {
                position: 1.0
                color: "#485563"
            }
        }

        RowLayout {
            id: footerLayout

            anchors {
                fill: parent
                leftMargin: 30
                rightMargin: 30
            }

            spacing: 10

            Repeater {
                model: [
                    "صفحه اصلی",
                    "شارژرها",
                    "گزارش‌ها",
                    "تنظیمات",
                    "درباره ما"
                ]

                delegate: Rectangle {
                    id: navigationItem

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: main.currentPageIndex === index
                           ? "#35FFFFFF"
                           : "transparent"

                    radius: 8

                    Text {
                        anchors.centerIn: parent

                        text: modelData
                        color: "white"

                        font.pixelSize: 18
                        font.bold: main.currentPageIndex === index
                    }

                    Rectangle {
                        anchors {
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                            bottomMargin: 5
                        }

                        width: parent.width * 0.45
                        height: 3
                        radius: 2

                        color: "white"
                        visible: main.currentPageIndex === index
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            main.currentPageIndex = index
                        }
                    }
                }
            }
        }
    }
}
