import 'package:flutter/material.dart';

class Option {
  String option_id;
  String gID;
  String title;
  bool selected;

  Option({required this.gID,required  this.option_id,required this.title, this.selected = false});
}

class Group {
  String groupName;
  String group_id;
  List<Option> options;

  Group({required this.group_id,required this.groupName, required this.options});
}

class GroupedRadioListExample extends StatefulWidget {
  @override
  _GroupedRadioListExampleState createState() => _GroupedRadioListExampleState();
}

class _GroupedRadioListExampleState extends State<GroupedRadioListExample> {
  List<Group> groups = [
    Group(
      groupName: 'Group 1',
      group_id: 'G1',
      options: [
        Option(title: 'Option 1.1',option_id: 'op11',gID: 'G1'),
        Option(title: 'Option 1.2', option_id: 'op12',gID: 'G1'),
        Option(title: 'Option 1.3', option_id: 'op13',gID: 'G1'),
      ],
    ),
    Group(
      groupName: 'Group 2',
      group_id: 'G2',
      options: [
        Option(title: 'Option 2.1', option_id: 'op21',gID: 'G2'),
        Option(title: 'Option 2.2', option_id: 'op22',gID: 'G2'),
        Option(title: 'Option 2.3', option_id: 'op23',gID: 'G2'),
      ],
    ),
    Group(
      groupName: 'Group 3',
      group_id: 'G3',
      options: [
        Option(title: 'Option 3.1', option_id: 'op31',gID: 'G3'),
        Option(title: 'Option 3.2', option_id: 'op32',gID: 'G3'),
        Option(title: 'Option 3.3', option_id: 'op33',gID: 'G3'),
      ],
    ),
    Group(
      groupName: 'Group 4',
      group_id: 'G4',
      options: [
        Option(title: 'Option 4.1', option_id: 'op41',gID: 'G4'),
        Option(title: 'Option 4.2', option_id: 'op42',gID: 'G4'),
        Option(title: 'Option 4.3', option_id: 'op43',gID: 'G4'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  List optionValue = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Grouped Radio List Example'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(groups[index].groupName),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: groups[index].options.length,
                itemBuilder: (context, optionIndex) {
                  return RadioListTile(
                    title: Text(groups[index].options[optionIndex].title),
                    value: optionIndex,
                    groupValue: groups[index].options.indexWhere((option) => option.selected),
                    onChanged: (value) {
                      setState(() {
                        for (int i = 0; i < groups[index].options.length; i++) {
                          groups[index].options[i].selected = (i == value);
                        }
                        // Add or update selection in optionValue list for this group
                        Option selectedOption = groups[index].options[value!];
                        int existingIndex = optionValue.indexWhere((element) => element.gID == selectedOption.gID);
                        if (existingIndex != -1) {
                          optionValue[existingIndex] = selectedOption;
                        } else {
                          optionValue.add(selectedOption);
                        }
                        print('-------$optionValue');
                      });
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
