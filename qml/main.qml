import QtQuick 2.13
import QtQuick.Controls 2.13

ApplicationWindow {
  id: window
  visible: true
  width: 640
  height: 480
  title: qsTr("App")

  StackView {
    id: stackView
    initialItem: "FileSelector.qml"
    anchors.fill: parent
  }
}
