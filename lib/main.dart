import 'dart:async';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final Color color;

  const Event({required this.title, required this.color});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isTapped = false;  // Tracks if the button is pressed
  double _radius = 0.0;

  void _onTap() {
    setState(() {
      _isTapped = true;  // Start the animation
      _radius = 1.0;  // Expands the radial effect to cover the button
    });

    // Wait for the animation to complete before navigating
    Timer(Duration(milliseconds: 500), () {
      // Reset button state
      setState(() {
        _isTapped = false;
        _radius = 0.0;  // Reset the radius for future taps
      });

      // Navigate to the new screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => NewScreen()),
      // );
    });
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Sample event data
  final Map<DateTime, List<String>> _events = {
    DateTime.now(): ['Meeting with Alex', 'Project Review', "Harshit id done"],
    DateTime.now().add(const Duration(days: 2)): ['Dinner with Sarah'],
    DateTime.now().subtract(const Duration(days: 2)): ['Gym', 'Doctor Appointment'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return _events.entries
        .firstWhere(
          (entry) => isSameDay(entry.key, day),
      orElse: () => MapEntry(DateTime.now(), []),
    )
        .value;
  }

  bool _isEventDay(DateTime day) {
    return _events.entries.any((entry) => isSameDay(entry.key, day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            _buttonWithEffect(),
            // _buttonWithEffect2(),
            TableCalendar(
              availableGestures: AvailableGestures.horizontalSwipe,
              weekNumbersVisible: false,
              currentDay: DateTime.now(),
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              eventLoader: _getEventsForDay,
              calendarStyle: const CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  if (day.weekday == DateTime.sunday) {
                    // final text = DateFormat.E().format(day);

                    return Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
                defaultBuilder: (context, day, focusedDay) {
                  if (day.weekday == DateTime.sunday) {
                    return Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (_isEventDay(day)) {
                    return Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.red),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        // style: TextStyle(color: Colors.white),  // Text color for event dates
                      ),
                    );
                  }
                  return null;
                },
                // singleMarkerBuilder: (context, date, event) {
                //   return Container(
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         // borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                //         color: //date == _selectedDay
                //              Colors.blue
                //         //     : event.color
                //     ), //Change color
                //     width: 10.0,
                //     height: 5.0,
                //     margin: const EdgeInsets.symmetric(horizontal: 1.5),
                //   );
                // },
              ),
              headerStyle: HeaderStyle(
                  // titleTextStyle:
                  // const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  formatButtonVisible: false,
                  titleCentered: true,
                  // headerPadding: const EdgeInsets.only(bottom: 8, top: 0),
                  // headerMargin: const EdgeInsets.only(bottom: 12),
                  // decoration: BoxDecoration(
                  //   // color: AppColors.punchOut,
                  //     border: Border(
                  //         bottom: BorderSide(
                  //             width: 1.5, color: Theme.of(context).dividerColor)))
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: _buildEventList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);
    if (events.isEmpty) {
      return const Center(child: Text('No events for selected day'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: const Icon(Icons.event),
            // onTap: () => print('${events[index]}'),
            title: Text('${events[index]}'),
          ),
        );
      },
    );
  }

  Widget _buttonWithEffect2(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: GestureDetector(
          onTap: _onTap,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: _isTapped ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 1600), // Duration of fill effect
            curve: Curves.easeOutCirc,
            builder: (context, value, child) {
              return Container(
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.lerp(Colors.transparent, Colors.blue, value), // Animate from transparent to blue
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Text(
                  'Press Me',
                  style: TextStyle(
                    color: _isTapped ? Colors.white : Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buttonWithEffect(){
    return Center(
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 800), // Slower animation
          curve: Curves.easeInOut, // Smooth transition curve
          width: 120,
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
            gradient: RadialGradient(
              center: Alignment.center,
              radius: _isTapped ? _radius : 0.0,
              colors: [
                Colors.blue,
                Colors.white,
              ],
            ),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Text(
            'Press Me',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Screen")),
      body: Center(child: Text("Welcome to the new screen!")),
    );
  }
}