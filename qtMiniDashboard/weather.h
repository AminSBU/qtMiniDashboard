#ifndef WEATHER_H
#define WEATHER_H

#include <QDeclarativeItem>
#include <QMainWindow>
#include <QObject>
#include <QQuickItem>

class weather : public QObject
{
    Q_OBJECT
public:
    explicit weather(QObject *parent = nullptr);

    Q_INVOKABLE void fetchWeather(const QString &cityName);

signals:

};

#endif // WEATHER_H
