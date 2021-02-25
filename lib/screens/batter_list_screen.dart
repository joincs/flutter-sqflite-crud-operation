import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite_battery/helpers/database_helpers.dart';
import 'package:sqflite_battery/models/BatteryModels.dart';
import 'package:sqflite_battery/screens/add_battery_screen.dart';

class BatteryListScreen extends StatefulWidget {
  @override
  _BatteryListScreenState createState() => _BatteryListScreenState();
}

class _BatteryListScreenState extends State<BatteryListScreen> {
  Future<List<Battery>> _batteryList;
  final DateFormat _dateFormatter = DateFormat('MMM dd,yyyy');

  @override
  void initState() {
    super.initState();
    _updateBatteryList();
  }

  _updateBatteryList() {
    setState(() {
      _batteryList = DatabaseHelper.instance.getBatteryList();
    });
  }

  Widget _buildBattery(Battery battery) {
    final double _borderRadius = 24;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                gradient: LinearGradient(
                  colors: [
                    battery.chargeStatus == "Empty" ? Colors.pink : Colors.blue,
                    battery.chargeStatus == "Empty" ? Colors.red : Colors.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: battery.chargeStatus == "Empty"
                        ? Colors.red
                        : Colors.blue,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ],
                color:
                    battery.chargeStatus == "Empty" ? Colors.red : Colors.blue,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: CustomPaint(
                size: Size(100, 150),
                painter: CustomCardShapePainter(
                  _borderRadius,
                  battery.chargeStatus == "Empty" ? Colors.pink : Colors.blue,
                  battery.chargeStatus == "Empty" ? Colors.red : Colors.blue,
                ),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: battery.chargeStatus == "Empty"
                          ? Lottie.asset(
                              'assets/animation/lowBattery.json',
                              height: 64,
                              width: 64,
                            )
                          : Container(
                              color: Colors.white,
                              child: Lottie.asset(
                                'assets/animation/Batteryfull.json',
                                height: 64,
                                width: 64,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          battery.name,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          battery.batteryType,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "Last Charge: ${_dateFormatter.format(battery.date)}",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddBatteryScreen(
                                updateBatteryList: _updateBatteryList,
                                battery: battery,
                              ),
                            ),
                          ),
                          child: Text(
                            "...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddBatteryScreen(
              updateBatteryList: _updateBatteryList,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _batteryList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: 60,
            ),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data.length == 0
                            ? "No Battery Available"
                            : "My Batteries",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      if (snapshot.data.length == 0)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddBatteryScreen(
                                  updateBatteryList: _updateBatteryList,
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: Lottie.asset('assets/animation/noData.json'),
                          ),
                        )
                    ],
                  ),
                );
              }

              return _buildBattery(snapshot.data[index - 1]);
            },
          );
        },
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();

    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
