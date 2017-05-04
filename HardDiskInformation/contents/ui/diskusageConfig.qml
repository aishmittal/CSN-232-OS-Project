

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons

ConfigGeneral {
    id: root

    onSourceAdded: {
        var match = source.match(/^partitions(.+)\/filllevel/);
        if (match) {
            root.addSource(source, match[1]);
        }
    }
}
