import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Dialogs 1.0

Item {
    
    property alias cfg_refresh: refresh.value
    property alias cfg_fontSize: fontSize.value
    property alias cfg_backColor: backColorDialog.color
    property alias cfg_foreColor: foreColorDialog.color
    property alias cfg_headerColor: headerColorDialog.color
    property alias cfg_listOpacity: listOpacity.value
    
    GridLayout {
        Layout.fillWidth: true
        rowSpacing: 10
        columnSpacing: 10
        columns: 2
        
        Text {
            text: "Reload time (seconds)"
        }
        SpinBox {
            id: refresh
            decimals: 0
            stepSize: 1
            minimumValue: 1
            maximumValue: 1800
        }

        Text {
            text: "Font Size"
        }
        SpinBox {
            id: fontSize
            decimals: 0
            stepSize: 2
            minimumValue: 2
            maximumValue: 48
        }
       
     
        Text {
            text: "Background Color"
        }
        Rectangle {
            id: backColor
            width: 50
            height: 17
            color: backColorDialog.color
            border.color: "black"
            border.width: 1
            radius: 0
            MouseArea{
                anchors.fill: parent
                onClicked: { backColorDialog.open(parent) }
            }
        }
        Text {
            text: "Foreground Color"
        }
        Rectangle {
            id: foreColor
            width: 50
            height: 17
            color: foreColorDialog.color
            border.color: "black"
            border.width: 1
            radius: 0
            MouseArea{
                anchors.fill: parent
                onClicked: { foreColorDialog.open() }
            }
        }
        Text {
            text: "Header Color"
        }
        Rectangle {
            id: headerColor
            width: 50
            height: 17
            color: headerColorDialog.color
            border.color: "black"
            border.width: 1
            radius: 0
            MouseArea{
                anchors.fill: parent
                onClicked: { headerColorDialog.open() }
            }
        }
        
        Text {
            text: "Opacity"
        }
        SpinBox {
            id: listOpacity
            decimals: 2
            stepSize: .05
            minimumValue: 0
            maximumValue: 1
        }
        
    }
    
    ColorDialog {
        id: backColorDialog
        color: "red"
        title: "Please choose a color"
        showAlphaChannel: true
        onAccepted: {
            backColor.color = colorbackDialog.color
        }
    }
    
    ColorDialog {
        id: foreColorDialog
        title: "Please choose a color"
        color: "green"
        onAccepted: {
            foreColor.color = colorforeDialog.color
        }
    }
    
    ColorDialog {
        id: headerColorDialog
        color: "Steel Blue"
        title: "Please choose a color"
        onAccepted: {
            backColor.color = colorbackDialog.color
        }
    }
    
}
