import QtQuick 2.9
import QtQuick.Window 2.2
import QtWebView 1.1
import io.decovar.WebSocketTransport 1.0
import QtWebChannel 1.0
import QtWebSockets 1.1
import QtQuick.Controls 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Catch Window Close Event in the Webview")

    Button {
        id: button
        anchors.top: parent.top
        anchors.left: parent.left
        text: "Open Browser"
        onClicked: {
            browser.source = "WebBrowser.qml"
            browser.visible = true
            browser.z = 3
        }
        z: 2
    }

    Loader {
        id: browser
        anchors.fill: parent
        z: -1
    }
}
