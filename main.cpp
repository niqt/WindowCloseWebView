#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QtWebEngine/qtwebengineglobal.h>
#include <QtWebView>
#include <websockettransport.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    //QtWebEngine::initialize();
    QtWebView::initialize();
    QQmlContext *rootContext = engine.rootContext();
    QString path = QStandardPaths::standardLocations(QStandardPaths::DataLocation).at(0);;
    qDebug() << "path " << path;
    QString dum = path + "/ios/";
    QDir d(".");
    qDebug() << d.absolutePath();
    qDebug() << d.entryList (QStringList());
    QFile f;
    f.setFileName(dum + "/niqt.html");
    if (f.exists())
        qDebug() << "EXIST " << dum;
    rootContext->setContextProperty("path", d.absolutePath());

    qmlRegisterType<WebSocketTransport>("io.decovar.WebSocketTransport", 1, 0, "WebSocketTransport");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
