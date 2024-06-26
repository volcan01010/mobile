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

/*
 * Caller si responsible for setting up bottom safe area in pageContent!
 * Top, left and right safe areas are already handled by the component
 */
Page {
  id: root

  property alias pageHeader: mmheader
  property alias pageContent: contentGroup.children

  property real pageBottomMargin: __style.margin20
  property int pageBottomMarginPolicy: MMPage.BottomMarginPolicy.UseMargin

  signal backClicked()

  enum BottomMarginPolicy { UseMargin, PaintBehindSystemBar }

  implicitHeight: ApplicationWindow.window?.height ?? 0
  implicitWidth: ApplicationWindow.window?.width ?? 0

  focus: true

  background: Rectangle {
    color: __style.lightGreenColor
  }

  header: MMPageHeader {
    id: mmheader

    width: parent?.width ?? 0
    color: __style.lightGreenColor

    onBackClicked: root.backClicked()
  }

  // TODO: use content item for this element
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

    height: {
      if ( pageBottomMarginPolicy === MMPage.BottomMarginPolicy.UseMargin ) {
        return parent.height - root.pageBottomMargin
      }
      else {
        return parent.height
      }
    }
    width: parent.width - leftPadding - rightPadding

    // center the content
    x: leftPadding
  }

  Keys.onReleased: function( event ) {
    if ( event.key === Qt.Key_Back || event.key === Qt.Key_Escape ) {
      root.backClicked()
      event.accepted = true
    }
  }
}
