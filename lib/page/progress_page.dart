import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:meteo_app/model/weather.dart';

import 'detail_page.dart';


class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Timer _timer;
  Random random = Random();
  late Timer _messageTimer;
  double _progress = 0;
  List<Weather> weathers = [];
   List<String> _messages = [
    "We are downloading the data...",
    "Only a few seconds before having the result..."
  ];
  List<String> originalistVille = [
    "Dakar",
    "Diourbel",
    "Fatick",
    "Kaffrine",
    "Kaolack",
    "Kédougou",
    "Kolda",
    "Louga",
    "Matam",
    "Saint-Louis",
    "Sédhiou",
    "Tambacounda",
    "Ziguinchor"
  ];
    List<String> listVille = [
      "Dakar",
      "Diourbel",
      "Fatick",
      "Kaffrine",
      "Kaolack",
      "Kédougou",
      "Kolda",
      "Louga",
      "Matam",
      "Saint-Louis",
      "Sédhiou",
      "Tambacounda",
      "Ziguinchor"
   ];
   bool added = false;
  int _messageIndex = 0;
  bool done = false;

  @override
  void initState() {
    super.initState();
    _startProgress();
    _startMessageRotation();
  }

  void _startProgress() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if(_progress % 20 == 0 && _progress<100){
        chercherDonnerPays();
      }
      setState(() {

        _progress += 5;
        // Fill up to 100% in 60 seconds
        if(!added && _progress > 50) {
          _messages.add(    "It's almost finished..."
          );
          added = true;
        }

        if (_progress >= 100) {
          timer.cancel();
          _messageTimer.cancel();
          setState(() {
            done =true;
          });

          // Here, you would call your weather API and display the results
        }
      });
    });
  }

  void _startMessageRotation() {
    _messageTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargement des donnes meteo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              done ? "DONE !!! " : _messages[_messageIndex],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if(!done)FAProgressBar(
              maxValue: 100,
              animatedDuration: const Duration(milliseconds: 3000),
              currentValue: _progress,
              displayText: '%',
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
            ),
            const SizedBox(height: 20),
            if (done)
              ElevatedButton(
                onPressed: () {
                  // Reset the state and restart the process
                  setState(() {
                    _progress = 0;
                    _messages = [
                      "We are downloading the data...",
                      "Only a few seconds before having the result..."
                    ];
                    _messageIndex = 0;
                    added = false;
                    done = false;
                    _startProgress();
                    _startMessageRotation();
                    weathers = [];
                    listVille = [...originalistVille];
                  });
                },
                child: Text('Recommencer'),
              ),
            const SizedBox(height: 20),
            if (done)
              Expanded(
                child: ListView.builder(
                  itemCount: weathers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(weathers[index].condition), // Display the weather condition image
                      title: Text(weathers[index].name),
                      subtitle: Text('Temperature: ${weathers[index].temp}°C'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(weather: weathers[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            // Here, you would display the results from the weather API
          ],
        ),
      ),
    );
  }


  void chercherDonnerPays() async {
    String town = listVille.removeAt(Random().nextInt(listVille.length));
    print(listVille);
    Uri uri = Uri.parse("http://api.weatherapi.com/v1/current.json?key=2b86665084dd4100866151506241203&q=$town,Senegal");
    http.Response  response = await http.get(uri);
    if(response.statusCode == 200){
      var values = jsonDecode(response.body);
      Weather weather =  Weather(values);
      weathers.add(weather);
      print(weather.toString());
    }

  }
}
