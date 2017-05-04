

import QtQuick 2.0
import QtQuick.Controls 1.1 as Controls
import QtQuick.Layouts 1.1 as Layouts

import org.kde.plasma.core 2.0 as PlasmaCore


Item {
    id: iconsPage
    width: childrenRect.width
    height: childrenRect.height
    implicitWidth: mainColumn.implicitWidth
    implicitHeight: mainColumn.implicitHeight

    property var cfg_sources: []
    onCfg_sourcesChanged: {
        if (cfg_sources.length == 0) {
            for (var i in mainColumn.children) {
                var child = mainColumn.children[i];
                if (child.checked !== undefined) {
                    child.checked = true;
                }
            }
        } else {
            for (var i in mainColumn.children) {
                var child = mainColumn.children[i];
                if (child.checked !== undefined) {
                    child.checked = cfg_sources.indexOf(child.source) !== -1;
                }
            }
        }
    }

    signal sourceAdded(string source)

    function addSource(source, friendlyName) {
        var found = false;
        for (var i = 0; i < sourcesModel.count; ++i) {
            var obj = sourcesModel.get(i);
            if (obj.source == source) {
                found = true;
                break;
            }
        }
        if (found) {
            return;
        }

        sourcesModel.append(
                {"source": encodeURIComponent(source),
                 "friendlyName": friendlyName});
    }

    PlasmaCore.DataSource {
        id: smSource

        engine: "systemmonitor"

        onSourceAdded: {
            iconsPage.sourceAdded(source);
        }
        onSourceRemoved: {
            for (var i = sourcesModel.count - 1; i >= 0; --i) {
                var obj = sourcesModel.get(i);
                if (obj.source == source) {
                    sourcesModel.remove(i);
                }
            }
        }
    }

    Component.onCompleted: {
        for (var i in smSource.sources) {
            var source = smSource.sources[i];
            iconsPage.sourceAdded(source);
        }
    }

    ListModel {
        id: sourcesModel
    }

    Layouts.ColumnLayout {
        id: mainColumn

        Repeater {
            id: repeater
            model: sourcesModel
            Controls.CheckBox {
                id: checkBox
                text: model.friendlyName
                property string source: model.source
                onCheckedChanged: {
                    if (checked) {
                        if (cfg_sources.indexOf(model.source) == -1) {
                            cfg_sources.push(model.source);
                        }
                    } else {
                        var idx = cfg_sources.indexOf(model.source);
                        if (idx !== -1) {
                            cfg_sources.splice(idx, 1);
                        }
                    }
                    cfg_sourcesChanged();
                }
            }
        }
    }
}
