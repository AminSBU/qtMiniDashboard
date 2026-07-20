#ifndef WEATHER_H
#define WEATHER_H

#include <QObject>
#include <QQuickItem>
#include <QNetworkAccessManager>

class weather : public QObject
{
    Q_OBJECT
public:
    explicit weather(QObject *parent = nullptr);

private:

signals:

};

#endif // WEATHER_H
