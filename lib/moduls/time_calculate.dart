import 'package:flutter/material.dart';

class TimeAdjuster extends StatefulWidget {
  const TimeAdjuster({super.key});

  @override
  _TimeAdjusterState createState() => _TimeAdjusterState();
}

class _TimeAdjusterState extends State<TimeAdjuster> {
  String? message;
  int totalMinutes = 110;
  int hours = 0;
  int minutes = 0;

  bool canAddMinutes(int additionalMinutes) {
    return (hours * 60 + minutes + additionalMinutes) <= totalMinutes;
  }

  bool canSubtractMinutes(int subtractMinutes) {
    return (hours * 60 + minutes - subtractMinutes) >= 0;
  }

  calculateRemainingDay() {
    // Current date
    DateTime currentDate = DateTime.now();
    // Project deadline date (e.g., June 15, 2024)
    DateTime projectDeadline = DateTime(2024, 6, 15);
    // Calculate the difference in days
    int daysRemaining = projectDeadline.difference(currentDate).inDays;

    if (daysRemaining > 0) {
      message = 'Days remaining project deadline: $daysRemaining later';
    } else if (daysRemaining < 0) {
      message = 'The project deadline was ${-daysRemaining} days ago';
    } else {
      message = 'Today is the project deadline';
    }
  }

  @override
  void initState() {
    calculateRemainingDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time calculate')),
      body: Column(
        children: [
          Text(
            message ?? '',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Date Time : $hours : H      ||       $minutes : M',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: canAddMinutes(15) ? Colors.black : Colors.pink,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (canSubtractMinutes(15)) {
                          setState(() {
                            minutes -= 15;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    const Text('15 min'),
                    IconButton(
                      onPressed: () {
                        if (canAddMinutes(15)) {
                          setState(() {
                            minutes += 15;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: canAddMinutes(30) ? Colors.black : Colors.pink,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (canSubtractMinutes(30)) {
                          setState(() {
                            minutes -= 30;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    const Text('30 min'),
                    IconButton(
                      onPressed: () {
                        if (canAddMinutes(30)) {
                          setState(() {
                            minutes += 30;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: canAddMinutes(60) ? Colors.black : Colors.pink,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (canSubtractMinutes(60)) {
                          setState(() {
                            hours -= 1;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    const Text('1 hour'),
                    IconButton(
                      onPressed: () {
                        if (canAddMinutes(60)) {
                          setState(() {
                            hours += 1;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: canAddMinutes(120) ? Colors.black : Colors.pink,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (canSubtractMinutes(120)) {
                          setState(() {
                            hours -= 2;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    const Text('2 hour'),
                    IconButton(
                      onPressed: () {
                        if (canAddMinutes(120)) {
                          setState(() {
                            hours += 2;
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
