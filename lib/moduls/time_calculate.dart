import 'package:flutter/material.dart';

class TimeAdjuster extends StatefulWidget {
  const TimeAdjuster({super.key});

  @override
  _TimeAdjusterState createState() => _TimeAdjusterState();
}

class _TimeAdjusterState extends State<TimeAdjuster> {
  String? message;
  int totalMinutes = 240;
  int hours = 0;
  int minutes = 0;

  bool canAddMinutes(int additionalMinutes) {
    return (hours * 60 + minutes + additionalMinutes) <= totalMinutes;
  }

  bool canSubtractMinutes(int subtractMinutes) {
    return (hours * 60 + minutes - subtractMinutes) >= 0;
  }

  void addMinutes(int additionalMinutes) {
    if (canAddMinutes(additionalMinutes)) {
      setState(() {
        minutes += additionalMinutes;
        normalizeTime();
      });
    }
  }

  void subtractMinutes(int subtractMinutes) {
    if (canSubtractMinutes(subtractMinutes)) {
      setState(() {
        minutes -= subtractMinutes;
        normalizeTime();
      });
    }
  }

  void normalizeTime() {
    if (minutes >= 60) {
      hours += minutes ~/ 60;
      minutes = minutes % 60;
    } else if (minutes < 0) {
      int absMinutes = minutes.abs();
      int hoursToSubtract = (absMinutes ~/ 60) + 1;
      minutes = 60 - (absMinutes % 60);
      hours -= hoursToSubtract;

      // If hours become negative, set to 0 and adjust minutes accordingly
      if (hours < 0) {
        hours = 0;
        minutes = 0;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int totalAddedMinutes = hours * 60 + minutes;
    return Scaffold(
      appBar: AppBar(title: const Text('Time Calculator')),
      body: Column(
        children: [
          Text(
            'Date Time: $hours H || $minutes M',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Total Added Minutes: $totalAddedMinutes',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              timeAdjustmentContainer(15, '15 min'),
              timeAdjustmentContainer(30, '30 min'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              timeAdjustmentContainer(60, '1 hour'),
              timeAdjustmentContainer(120, '2 hours'),
            ],
          ),
        ],
      ),
    );
  }

  Widget timeAdjustmentContainer(int minutes, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: canSubtractMinutes(minutes)
                ? () => subtractMinutes(minutes)
                : null,
            icon: const Icon(Icons.remove),
            color: canSubtractMinutes(minutes) ? Colors.green : Colors.grey,
          ),
          Text(label),
          IconButton(
            onPressed:
                canAddMinutes(minutes) ? () => addMinutes(minutes) : null,
            icon: const Icon(Icons.add),
            color: canAddMinutes(minutes) ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class UpdateScreen extends StatefulWidget {
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final List<Update> _updates = [
    Update('Update New', DateTime(2024, 6, 11, 10, 0)),
    Update('Update TEst hds', DateTime(2024, 6, 12, 9, 0)),
    Update('Update TEst hds', DateTime(2024, 6, 13, 9, 20)),
  ];
  List<Update> get updates => _updates;

  void addUpdate(Update update) {
    setState(() {
      _updates.add(update);
    });
  }

  bool canEdit(Update update) {
    final now = DateTime.now();
    final difference = now.difference(update.timestamp);
    return difference.inHours < 24;
  }

  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updates'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: updates.length,
              itemBuilder: (context, index) {
                final update = updates[index];
                return ListTile(
                  title: Text(update.content),
                  subtitle: Text(update.timestamp.toString()),
                  trailing: canEdit(update)
                      ? IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Edit update logic
                          },
                        )
                      : null,
                );
              },
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: isError ? Colors.red : Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NAME'),
                        TextFormField(
                          controller: controller,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                isError
                    ? const Text(
                        'PLease Enter Name',
                        style: TextStyle(color: Colors.red),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (controller.text.isEmpty) {
                  setState(() {
                    isError = true;
                  });
                }
              },
              child: const Text('Submit'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final now = DateTime.now();
          print('------>$now');
          addUpdate(Update('New update', now));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Update {
  final String content;
  final DateTime timestamp;

  Update(this.content, this.timestamp);
}
