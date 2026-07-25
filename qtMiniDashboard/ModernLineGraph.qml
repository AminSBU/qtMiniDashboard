import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    width: 760
    height: 100
    radius: 22

    color: "#111827"
    border.color: "#253248"
    border.width: 1

    // عنوان نمودار
    property string title: "نمودار توان خروجی"

    // واحد داده
    property string unit: "kW"

    // داده‌های نمودار
    property var values: [
        12, 18, 16, 28, 35, 32,
        48, 55, 52, 68, 72, 80
    ]

    // تعداد داده‌هایی که نگهداری می‌شوند
    property int maximumSamples: 30

    // رنگ اصلی نمودار
    property color lineColor: "#38BDF8"
    property color fillColor: "#0EA5E9"

    property int hoverIndex: -1

    readonly property real plotLeft: 58
    readonly property real plotRight: 24
    readonly property real plotTop: 25
    readonly property real plotBottom: 45

    readonly property real plotWidth:
        Math.max(1, graphCanvas.width - plotLeft - plotRight)

    readonly property real plotHeight:
        Math.max(1, graphCanvas.height - plotTop - plotBottom)

    signal sampleAdded(real value)

    /*
      برای جلوگیری از مشکل تغییر مستقیم آرایه در QML،
      همیشه یک آرایه جدید ساخته و به values اختصاص داده می‌شود.
    */
    function appendValue(value) {
        var newValues = values.slice()

        newValues.push(Number(value))

        while (newValues.length > maximumSamples)
            newValues.shift()

        values = newValues
        sampleAdded(value)
    }

    function setValues(newValues) {
        values = newValues.slice()
    }

    function clear() {
        values = []
        hoverIndex = -1
    }

    function minimumValue() {
        if (!values || values.length === 0)
            return 0

        var minValue = Number(values[0])

        for (var i = 1; i < values.length; ++i)
            minValue = Math.min(minValue, Number(values[i]))

        return minValue
    }

    function maximumValue() {
        if (!values || values.length === 0)
            return 100

        var maxValue = Number(values[0])

        for (var i = 1; i < values.length; ++i)
            maxValue = Math.max(maxValue, Number(values[i]))

        return maxValue
    }

    function graphMinimum() {
        var minValue = minimumValue()
        var maxValue = maximumValue()
        var range = Math.max(1, maxValue - minValue)

        return minValue - range * 0.15
    }

    function graphMaximum() {
        var minValue = minimumValue()
        var maxValue = maximumValue()
        var range = Math.max(1, maxValue - minValue)

        return maxValue + range * 0.15
    }

    function xPosition(index) {
        if (!values || values.length <= 1)
            return plotLeft + plotWidth / 2

        return plotLeft +
               (index / (values.length - 1)) * plotWidth
    }

    function yPosition(value) {
        var minValue = graphMinimum()
        var maxValue = graphMaximum()
        var range = Math.max(1, maxValue - minValue)

        return plotTop +
               plotHeight -
               ((Number(value) - minValue) / range) * plotHeight
    }

    onValuesChanged: {
        graphCanvas.requestPaint()

        if (hoverIndex >= values.length)
            hoverIndex = -1
    }

    onWidthChanged: graphCanvas.requestPaint()
    onHeightChanged: graphCanvas.requestPaint()

    Behavior on lineColor {
        ColorAnimation {
            duration: 250
        }
    }

    // سایه پس‌زمینه
    Rectangle {
        anchors.fill: parent
        anchors.margins: 8
        radius: parent.radius
        color: "#45000000"
        z: -1

        transform: Translate {
            y: 8
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 12

        // بخش عنوان
        Row {
            width: parent.width
            height: 45
            spacing: 12

            Rectangle {
                width: 8
                height: 32
                radius: 4
                color: root.lineColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: root.title
                    color: "#F8FAFC"
                    font.pixelSize: 18
                    font.bold: true
                }

                Text {
                    text: root.values.length > 0
                          ? "آخرین مقدار: " +
                            Number(root.values[root.values.length - 1])
                                .toFixed(1) +
                            " " + root.unit
                          : "داده‌ای موجود نیست"

                    color: "#94A3B8"
                    font.pixelSize: 12
                }
            }

            Item {
                width: Math.max(
                           0,
                           parent.width - 300
                       )
                height: 1
            }

            Rectangle {
                width: 86
                height: 30
                radius: 15
                color: "#162D3C"
                border.color: "#1D4E63"

                anchors.verticalCenter: parent.verticalCenter

                Row {
                    anchors.centerIn: parent
                    spacing: 7

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: root.lineColor

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite

                            NumberAnimation {
                                from: 1.0
                                to: 0.3
                                duration: 700
                            }

                            NumberAnimation {
                                from: 0.3
                                to: 1.0
                                duration: 700
                            }
                        }
                    }

                    Text {
                        text: "LIVE"
                        color: "#BAE6FD"
                        font.pixelSize: 11
                        font.bold: true
                    }
                }
            }
        }

        // محدوده نمودار
        Item {
            id: chartArea

            width: parent.width
            height: parent.height - 57

            Canvas {
                id: graphCanvas

                anchors.fill: parent
                antialiasing: true

                onPaint: {
                    var ctx = getContext("2d")

                    ctx.reset()
                    ctx.clearRect(0, 0, width, height)

                    var minValue = root.graphMinimum()
                    var maxValue = root.graphMaximum()
                    var valueRange = Math.max(
                                1,
                                maxValue - minValue
                            )

                    // خطوط شبکه افقی
                    var horizontalLines = 5

                    ctx.lineWidth = 1
                    ctx.strokeStyle = "#253248"
                    ctx.fillStyle = "#7F8DA3"
                    ctx.font = "11px sans-serif"
                    ctx.textAlign = "right"
                    ctx.textBaseline = "middle"

                    for (var row = 0;
                         row <= horizontalLines;
                         ++row) {

                        var ratio = row / horizontalLines
                        var y = root.plotTop +
                                ratio * root.plotHeight

                        ctx.beginPath()
                        ctx.moveTo(root.plotLeft, y)
                        ctx.lineTo(
                            root.plotLeft + root.plotWidth,
                            y
                        )
                        ctx.stroke()

                        var axisValue =
                            maxValue - ratio * valueRange

                        ctx.fillText(
                            axisValue.toFixed(0),
                            root.plotLeft - 10,
                            y
                        )
                    }

                    // خطوط شبکه عمودی
                    var verticalLines = 6

                    for (var column = 0;
                         column <= verticalLines;
                         ++column) {

                        var xRatio = column / verticalLines
                        var x = root.plotLeft +
                                xRatio * root.plotWidth

                        ctx.beginPath()
                        ctx.moveTo(x, root.plotTop)
                        ctx.lineTo(
                            x,
                            root.plotTop + root.plotHeight
                        )
                        ctx.stroke()
                    }

                    if (!root.values ||
                            root.values.length === 0) {

                        ctx.fillStyle = "#64748B"
                        ctx.font = "14px sans-serif"
                        ctx.textAlign = "center"

                        ctx.fillText(
                            "داده‌ای برای نمایش وجود ندارد",
                            width / 2,
                            height / 2
                        )

                        return
                    }

                    // ساخت مسیر نمودار
                    ctx.beginPath()

                    for (var i = 0;
                         i < root.values.length;
                         ++i) {

                        var pointX = root.xPosition(i)
                        var pointY = root.yPosition(
                                    root.values[i]
                                )

                        if (i === 0)
                            ctx.moveTo(pointX, pointY)
                        else
                            ctx.lineTo(pointX, pointY)
                    }

                    // تکمیل مسیر برای رنگ زیر نمودار
                    ctx.lineTo(
                        root.xPosition(root.values.length - 1),
                        root.plotTop + root.plotHeight
                    )

                    ctx.lineTo(
                        root.xPosition(0),
                        root.plotTop + root.plotHeight
                    )

                    ctx.closePath()

                    var gradient = ctx.createLinearGradient(
                                0,
                                root.plotTop,
                                0,
                                root.plotTop +
                                root.plotHeight
                            )

                    gradient.addColorStop(
                                0,
                                Qt.rgba(
                                    root.fillColor.r,
                                    root.fillColor.g,
                                    root.fillColor.b,
                                    0.42
                                )
                            )

                    gradient.addColorStop(
                                1,
                                Qt.rgba(
                                    root.fillColor.r,
                                    root.fillColor.g,
                                    root.fillColor.b,
                                    0.01
                                )
                            )

                    ctx.fillStyle = gradient
                    ctx.fill()

                    // رسم مجدد خط اصلی
                    ctx.beginPath()

                    for (var j = 0;
                         j < root.values.length;
                         ++j) {

                        var lineX = root.xPosition(j)
                        var lineY = root.yPosition(
                                    root.values[j]
                                )

                        if (j === 0)
                            ctx.moveTo(lineX, lineY)
                        else
                            ctx.lineTo(lineX, lineY)
                    }

                    ctx.lineWidth = 3
                    ctx.lineJoin = "round"
                    ctx.lineCap = "round"
                    ctx.strokeStyle = root.lineColor
                    ctx.stroke()

                    // نقطه آخر نمودار
                    var lastIndex =
                        root.values.length - 1

                    var lastX =
                        root.xPosition(lastIndex)

                    var lastY =
                        root.yPosition(
                            root.values[lastIndex]
                        )

                    ctx.beginPath()
                    ctx.arc(lastX, lastY, 7, 0, Math.PI * 2)
                    ctx.fillStyle = "#111827"
                    ctx.fill()

                    ctx.lineWidth = 3
                    ctx.strokeStyle = root.lineColor
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(lastX, lastY, 3, 0, Math.PI * 2)
                    ctx.fillStyle = root.lineColor
                    ctx.fill()

                    // نمایش نقطه انتخاب‌شده
                    if (root.hoverIndex >= 0 &&
                            root.hoverIndex <
                            root.values.length) {

                        var hoverX =
                            root.xPosition(root.hoverIndex)

                        var hoverY =
                            root.yPosition(
                                root.values[root.hoverIndex]
                            )

                        ctx.beginPath()
                        ctx.moveTo(
                            hoverX,
                            root.plotTop
                        )
                        ctx.lineTo(
                            hoverX,
                            root.plotTop +
                            root.plotHeight
                        )

                        ctx.lineWidth = 1
                        ctx.strokeStyle = "#7895B2"
                        ctx.stroke()

                        ctx.beginPath()
                        ctx.arc(
                            hoverX,
                            hoverY,
                            6,
                            0,
                            Math.PI * 2
                        )

                        ctx.fillStyle = root.lineColor
                        ctx.fill()

                        ctx.lineWidth = 3
                        ctx.strokeStyle = "#E0F2FE"
                        ctx.stroke()
                    }
                }
            }

            MouseArea {
                id: chartMouseArea

                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton

                onPositionChanged: function(mouse) {
                    if (!root.values ||
                            root.values.length === 0) {
                        root.hoverIndex = -1
                        return
                    }

                    var relativeX =
                        mouse.x - root.plotLeft

                    var ratio =
                        relativeX / root.plotWidth

                    ratio = Math.max(
                                0,
                                Math.min(1, ratio)
                            )

                    root.hoverIndex = Math.round(
                                ratio *
                                (root.values.length - 1)
                            )

                    graphCanvas.requestPaint()
                }

                onExited: {
                    root.hoverIndex = -1
                    graphCanvas.requestPaint()
                }
            }

            // Tooltip
            Rectangle {
                id: tooltip

                visible: root.hoverIndex >= 0 &&
                         root.hoverIndex <
                         root.values.length

                width: 110
                height: 55
                radius: 10

                color: "#E61E293B"
                border.color: root.lineColor
                border.width: 1

                property real desiredX:
                    visible
                    ? root.xPosition(root.hoverIndex) -
                      width / 2
                    : 0

                property real desiredY:
                    visible
                    ? root.yPosition(
                          root.values[root.hoverIndex]
                      ) - height - 14
                    : 0

                x: Math.max(
                       5,
                       Math.min(
                           chartArea.width - width - 5,
                           desiredX
                       )
                   )

                y: Math.max(
                       5,
                       desiredY
                   )

                Column {
                    anchors.centerIn: parent
                    spacing: 3

                    Text {
                        anchors.horizontalCenter:
                            parent.horizontalCenter

                        text: root.hoverIndex >= 0
                              ? "نمونه " +
                                (root.hoverIndex + 1)
                              : ""

                        color: "#94A3B8"
                        font.pixelSize: 11
                    }

                    Text {
                        anchors.horizontalCenter:
                            parent.horizontalCenter

                        text: root.hoverIndex >= 0 &&
                              root.hoverIndex <
                              root.values.length
                              ? Number(
                                  root.values[root.hoverIndex]
                                ).toFixed(1) +
                                " " + root.unit
                              : ""

                        color: "#F8FAFC"
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
            }
        }
    }
}
