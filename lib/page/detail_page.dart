import 'package:flutter/material.dart';
import 'package:meteo_app/model/weather.dart';

class DetailPage extends StatelessWidget {
  final Weather weather;

  const DetailPage({Key? key, required Weather this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Temperature: ${weather.temp}°C'),
            Text('Cloud Coverage: ${weather.cloud}%'),
            Image.network(weather.condition),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
