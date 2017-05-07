/*!
  * KDE Plasma script to show a todo list
  *
  * Shubham Kumar <shubhamkumar.iitr@gmail.com>
  * 19.04.2016
  */
import QtQuick 1.0;

Item {
    id:root

    TextInput {
              id: q2
              text: "To Do List:"
              anchors.centerIn: parent
              cursorVisible: true
              mode: "auto_refresh"
          }
}
