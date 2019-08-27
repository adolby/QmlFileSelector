import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Layouts 1.13
import Qt.labs.folderlistmodel 2.13

Page {
  id: fileSelector
  property url fileUrl: app.selectedFile
  property url folder: app.folder
  property bool selectFolder: false

  FolderListModel {
    id: folderModel
    folder: fileSelector.folder
    showDirsFirst: true
    showHidden: true
    showFiles: !fileSelector.selectFolder
  }

  Component {
    id: fileRowDelegate

    Item {
      id: row
      property var item: model.modelData ? model.modelData : model
      width: parent.width
      height: childrenRect.height

      Image {
        id: icon
        source: item.fileIsDir ?
                "qrc:/resources/images/dirclosed-128.png" :
                "qrc:/resources/images/file-128.png"
        height: fileLabel.height
        width: height
        anchors.left: parent.left
        anchors.leftMargin: 8
      }

      Label {
        id: fileLabel
        text: item.fileName
        elide: Text.ElideLeft
        font.pixelSize: 24
        anchors.left: icon.visible ? icon.right : parent.left
        anchors.leftMargin: 8
      }

      MouseArea {
        anchors.fill: parent

        onClicked: {
          if (selectFolder) {
            app.updateSelectedFile(item.fileURL);

            // Navigate to new page
          } else {
            if (item.fileIsDir) {
              app.updateFolder(item.fileURL);
            } else {
              app.updateSelectedFile(item.fileURL);

              // Navigate to new page
            }
          }
        }
      }
    }
  }

  Component {
    id: fileToolBar

    ToolBar {
      width: parent.width
      z: 2

      RowLayout {
        anchors.fill: parent

        ToolButton {
          implicitHeight: 44

          icon.source: "qrc:/resources/images/left.png"
          icon.width: 30
          icon.height: 30
        }

        Label {
          text: fileSelector.folder
          elide: Label.ElideLeft
          horizontalAlignment: Qt.AlignHCenter
          verticalAlignment: Qt.AlignVCenter
          Layout.fillWidth: true
        }

        ToolButton {
          id: upButton
          implicitHeight: 44

          icon.source: "qrc:/resources/images/up-128.png"
          icon.width: 30
          icon.height: 30

          onClicked: {
            if (folderModel.parentFolder.toString() !== "") {
              app.updateFolder(folderModel.parentFolder);
            }
          }

          Layout.rightMargin: 5
        }
      }
    }
  }

  ListView {
    id: folderView
    model: folderModel
    delegate: fileRowDelegate
    footer: fileToolBar
    footerPositioning: ListView.OverlayFooter
    anchors.fill: parent
  }
}
