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

signals:

};

#endif // WEATHER_H
