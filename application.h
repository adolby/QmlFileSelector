#ifndef APPLICATION_H
#define APPLICATION_H

#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QObject>

class Application : public QGuiApplication {
  Q_OBJECT
  Q_PROPERTY(QUrl selectedFile READ selectedFile NOTIFY selectedFileChanged)
  Q_PROPERTY(QUrl folder READ folder NOTIFY folderChanged)

 public:
  explicit Application(int& argc, char** argv);

  static QUrl documentsLocation();

  QUrl selectedFile() const;
  QUrl folder() const;

 signals:
  void selectedFileChanged(const QUrl& url);
  void folderChanged(const QUrl& url);

 public slots:
  void updateSelectedFile(const QUrl& url);
  void updateFolder(const QUrl& url);

 private:
  QQmlApplicationEngine engine;
  QUrl fileUrl;
  QUrl folderUrl;
};

#endif // APPLICATION_H
