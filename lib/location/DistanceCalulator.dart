import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DistanceCalculator extends StatefulWidget {
  var LatlngList = {
    'type': String,
    'title': Object,
  };

  DistanceCalculator() {
    List<double> latlng = new List();
    latlng.add(23.0222372);
    latlng.add(72.4894835);
  }

  @override
  _DistanceCalculatorState createState() => _DistanceCalculatorState();
}

class _DistanceCalculatorState extends State<DistanceCalculator> {
  var distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, position) {
            return new Container(
              child: new Row(
                children: <Widget>[distanceCalCulator()],
              ),
            );
          }),
    );
  }

  Widget distanceCalCulator() {
    return new FutureBuilder(
        future: Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (!snapShot.hasData) return new Container();
          if (snapShot.hasData) {
            Position position = snapShot.data;
            return new FutureBuilder(
                future: Geolocator().distanceBetween(position.latitude,
                    position.longitude, 23.0299555, 72.5429805),
                builder: (BuildContext context, AsyncSnapshot snapShot) {
                   distance= snapShot.data;
                  return new Container(
                    child: new Text(distance.toString(),style: TextStyle(fontSize: 30),)
                  );

                });
          }
        });
  }
}
