import QtQuick 2.9
import QtQuick.Window 2.2
import QtWebView 1.1
import io.decovar.WebSocketTransport 1.0
import QtWebChannel 1.0
import QtWebSockets 1.1

Item {
    id: webBrowser
    signal close()

    WebSocketTransport {
        id: transport
        onMessageChanged: console.log("Message " + message)
    }

    WebSocketServer {
        id: server
        listen: true
        port: 55222
        onClientConnected: {
            if(webSocket.status === WebSocket.Open) {
                channel.connectTo(transport)
                webSocket.onTextMessageReceived.connect(transport.textMessageReceive)
                transport.onMessageChanged.connect(webSocket.sendTextMessage)
            }
        }
        onErrorStringChanged: {
            console.log(qsTr("Server error: %1").arg(errorString));
        }
    }

    QtObject {
        id: sharedObject

        // ID, under which this object will be known at WebEngineView side
        WebChannel.id: "backend"

        function changeText(message) {
            console.log("Message " + message)
            browser.source = ''
        }
    }

    WebChannel {
        id: channel
        registeredObjects: [sharedObject]
    }


    WebView {
        id: webView
        anchors.fill: parent
        url: (Qt.platform.os == "ios")? "file:///" + path + "/ios/niqt.html" : "qrc:///niqt.html"

        onLoadingChanged: {
            if (loadRequest.status === WebView.LoadSucceededStatus ) {
                var script = '
                    var backend;

                    var socket = new WebSocket("ws://127.0.0.1:55222");
                    socket.onopen = function()
                    {
                        new QWebChannel(socket, function(channel) {
                            backend = channel.objects.backend;
                        });
                    };

                    window.close = function() {
                       backend.changeText("close");
                    }

                    socket.onerror = function(evt) {
                        alert("on error");
                    }

                    socket.onclose = function(evt)
                    {
                        // websocket is closed.
                        alert("Connection is closed: " + evt.code + " - " + evt.reason);
                    };
                ';

                var file = "qrc:///qwebchannel.js"
                var xhr = new XMLHttpRequest;

                xhr.open("GET", file);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        var response = xhr.response;
                        runJavaScript(response);
                        runJavaScript(script)
                    }
                }
                xhr.send()
            }
        }
    }
}
