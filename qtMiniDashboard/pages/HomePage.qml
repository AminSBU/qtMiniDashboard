import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14

Page {
    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            topMargin: 70 + 10
            rightMargin: 10
            leftMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 15

        Text {
            text: "صفحه اصلی"
            color: "#29323c"
            font.pixelSize: 32
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        AnimatedImage {
            width: 200
            height: 200
            source: "qrc:/new/prefix1/fan.gif"
            fillMode: Image.PreserveAspectFit
        }
    }
}
