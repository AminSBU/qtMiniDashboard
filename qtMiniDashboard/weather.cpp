#include "weather.h"

weather::weather(QObject *parent) : QObject(parent)
{

}

void weather::fetchWeather(const QString &cityName)
{
    if(cityName.trimmed().isEmpty())
    {
        return;
    }
}
