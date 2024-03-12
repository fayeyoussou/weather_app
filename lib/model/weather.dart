class Weather {
  late String name;
  late double temp;
  late int cloud;

  late String condition;

  Weather(dynamic values){
    cloud = values["current"]["cloud"];
    temp = values["current"]["temp_c"];
    name = values["location"]["region"];
    condition = "http:${values["current"]["condition"]["icon"]}";
  }
 @override
  String toString() {
    //
    return "name : $name condition : $condition temp : $temp cloud : $cloud";
  }

}