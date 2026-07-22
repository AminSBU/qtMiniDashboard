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
            topMargin: 80
            rightMargin: 10
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

        Text {
            text: "به سامانه مدیریت شارژرهای برقی خوش آمدید"
            color: "#485563"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
