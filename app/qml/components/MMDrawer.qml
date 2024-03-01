/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

import QtQuick
import QtQuick.Controls

Drawer {
  id: root

  property bool hasHandle: false

  property alias drawerHeader: mmDrawerHeader
  property alias content: contentGroup.children

  property double drawerSpacing: __style.spacing40 // Change this to 20 if using searchbar

  property real maxHeight: ( ApplicationWindow.window?.height ?? 0 ) - __style.safeAreaTop


  implicitHeight: contentHeight > maxHeight ? maxHeight : contentHeight
  implicitWidth: ApplicationWindow.window?.width ?? 0

  edge: Qt.BottomEdge
  dragMargin: 0

  // rounded background
  background: Rectangle {
    color: __style.whiteColor
    radius: internal.radius

    Rectangle {
      width: parent.width / 10
      height: 4 * __dp

      anchors.top: parent.top
      anchors.topMargin: 8 * __dp
      anchors.horizontalCenter: parent.horizontalCenter

      visible: root.hasHandle

      radius: internal.radius

      color: __style.lightGreenColor
    }

    Rectangle {
      color: __style.whiteColor
      width: parent.width
      height: parent.height / 2
      y: parent.height / 2
    }
  }

  contentItem: Column {
    id: mainColumn

    anchors.fill: parent
    spacing: root.drawerSpacing

    height: mmDrawerHeader.height + contentGroup.height + root.drawerSpacing

    MMDrawerHeader {
      id: mmDrawerHeader

      width: parent.width

      onCloseClicked: {
        root.close()
      }
    }

    Item {
      id: contentGroup

      property real minLeftPadding: __style.pageMargins + __style.safeAreaLeft
      property real minRightPadding: __style.pageMargins + __style.safeAreaRight
      property real minSidesPadding: 2 * __style.pageMargins + __style.safeAreaLeft + __style.safeAreaRight

      property real leftPadding: {
        if ( parent.width > __style.maxPageWidth + minSidesPadding ) {
          let leftSideOverflow = ( parent.width - minSidesPadding - __style.maxPageWidth ) / 2
          return leftSideOverflow + minLeftPadding
        }

        return minLeftPadding
      }

      property real rightPadding: {
        if ( parent.width > __style.maxPageWidth + minSidesPadding ) {
          let rightSideOverflow = ( parent.width - minSidesPadding - __style.maxPageWidth ) / 2
          return rightSideOverflow + minRightPadding
        }

        return minRightPadding
      }

      height: childrenRect.height
      width: parent.width - leftPadding - rightPadding

      // center the content
      x: leftPadding
    }
  }

  QtObject {
    id: internal

    property real radius: 20 * __dp
  }
}