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

    background: Rectangle
    {
        gradient: Gradient
        {
            GradientStop{
                position: 0.0
                color: "#1E3C72"
            }

            GradientStop
            {
                position: 1.0
                color: "#2A5298"
            }
        }
    }

    GridLayout{
        id: grid
        anchors.fill: parent
        columns: 3
        columnSpacing: 10
        rowSpacing: 8

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            border.color: "white"
            color: "transparent"
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            border.color: "white"
            color: "transparent"
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            border.color: "white"
            color: "transparent"
        }
    }
}
