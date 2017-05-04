

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.kcoreaddons 1.0 as KCoreAddons

Applet {
    id: root

    onSourceAdded: {
        var match = source.match(/^partitions(.+)\/filllevel/);
        if (match) {
            var freeSource = "partitions" + match[1] + "/freespace";
            root.addSource(source, match[1], freeSource, match[1]);
        }
    }

    delegate: Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        PlasmaComponents.Label {
            id: label
            text: model.friendlyName1
            anchors {
                left: parent.left
                bottom: progressBar.top
            }
        }
        PlasmaComponents.Label {
            id: freeSpace
            anchors {
                right: parent.right
                bottom: progressBar.top
            }
        }
        PlasmaComponents.ProgressBar {
            id: progressBar
            minimumValue: 0
            maximumValue: 100
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }
        Connections {
            target: model.dataSource
            onNewData: {
                if (sourceName.indexOf(decodeURIComponent(model.source1)) != 0) {
                    return;
                }

                var data1 = model.dataSource.data[decodeURIComponent(model.source1)];
                var data2 = model.dataSource.data[decodeURIComponent(model.source2)];

                if (data1 !== undefined && data1.value !== undefined) {
                    progressBar.value = data1.value;
                }

                if (data2 !== undefined && data2.value !== undefined) {
                    freeSpace.text = KCoreAddons.Format.formatByteSize(data2.value * 1024);
                }
            }
        }
    }
}