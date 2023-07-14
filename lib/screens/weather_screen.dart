import 'dart:async';
import 'package:contador_wearable/screens/model.dart';
import 'package:contador_wearable/screens/service.dart';
import 'package:wear/wear.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WeatherWidget extends StatefulWidget {
  final WeatherService weatherService;
  final WearMode mode;

  const WeatherWidget(this.mode, {required this.weatherService});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late WeatherData _weatherData;
  late String _hourString;
  late String _minuteString;
  late String _amPmString;

  @override
  void initState() {
    super.initState();
    _weatherData = WeatherData(
      cityName: '',
      temperature: 0,
      description: '',
      iconUrl: '',
    );
    _getTime();
    _getWeather();
  }

  void _getTime() {
    final now = DateTime.now();
    final hourFormatter = DateFormat('hh');
    final minuteFormatter = DateFormat('mm');
    final amPmFormatter = DateFormat('a');
    _hourString = hourFormatter.format(now);
    _minuteString = minuteFormatter.format(now);
    _amPmString = amPmFormatter.format(now);
    Timer.periodic(Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final hourFormatter = DateFormat('hh');
      final minuteFormatter = DateFormat('mm');
      final amPmFormatter = DateFormat('a');
      setState(() {
        _hourString = hourFormatter.format(now);
        _minuteString = minuteFormatter.format(now);
        _amPmString = amPmFormatter.format(now);
      });
    });
  }

  Future<void> _getWeather() async {
    try {
      final weatherData =
          await widget.weatherService.getWeather('Tequisquiapan');
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.mode == WearMode.active
          ? Color.fromARGB(220, 241, 108, 7)
          : Color.fromARGB(255, 15, 18, 53),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_weatherData.cityName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_weatherData.temperature}°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _hourString+":"+_minuteString,
                        style:const TextStyle(
                          color: Colors.white,
                          
                          fontSize: 45,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      
                    ],
                  ),
                ),
                    Text(
                      _amPmString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                const SizedBox(
                  width: 2,
                ),
              ],
            ),
            const SizedBox(height: 5,),
            Text(
              DateFormat('EEEE d MMMM yyyy').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic
              ),
            ),
            
           
            
            const SizedBox(height: 5),
            
          ],
        ),
      ),
    );
  }
}
