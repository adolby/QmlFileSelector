#include "application.h"
#include <QQmlContext>
#include <QCoreApplication>
#include <QStandardPaths>
#include <QUrl>

Application::Application(int& argc, char** argv)
  : QGuiApplication(argc, argv) {
  QQmlContext* const context = engine.rootContext();

  context->setContextProperty(QStringLiteral("app"), this);

  const QUrl mainPage(QStringLiteral("qrc:/qml/main.qml"));

  QObject::connect(&engine,
                   &QQmlApplicationEngine::objectCreated,
                   QCoreApplication::instance(),
                   [this, mainPage](QObject* obj, const QUrl& objUrl) {
                     if (!obj && mainPage == objUrl) {
                       QCoreApplication::exit(-1);
                     }

                     updateFolder(Application::documentsLocation());
                   },
                   Qt::QueuedConnection);

  engine.load(mainPage);
}

QUrl Application::documentsLocation() {
  const QUrl& documentsLocation =
    QUrl::fromLocalFile(
      QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));

  return documentsLocation;
}

QUrl Application::selectedFile() const {
  return fileUrl;
}

QUrl Application::folder() const {
  return folderUrl;
}

void Application::updateSelectedFile(const QUrl& url) {
  fileUrl = url;
  emit selectedFileChanged(fileUrl);
}

void Application::updateFolder(const QUrl& url) {
  folderUrl = url;
  emit folderChanged(folderUrl);
}
