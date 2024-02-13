import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimeManagerPage(),
    );
  }
}

class Time {
  int minute;
  int hour;
  Time({
    required this.minute,
    required this.hour,
    String? date,
  });
}

class TimeManagerPage extends StatelessWidget {
  const TimeManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * .9,
            child: const SingleChildScrollView(
              child: TimeManagerForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class TextForm extends StatelessWidget {
  final String hintText;
  final void Function(int)? onChanged;

  const TextForm({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      onChanged:
          onChanged != null ? (value) => onChanged!(int.parse(value)) : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
    );
  }
}

class TimeManagerForm extends StatefulWidget {
  const TimeManagerForm({Key? key}) : super(key: key);

  @override
  State<TimeManagerForm> createState() => _TimeManagerFormState();
}

class _TimeManagerFormState extends State<TimeManagerForm> {
  final _formKey = GlobalKey<FormState>();
  int? hour;
  int? minute;

  List<Time> savedRegister = [];
  List<Color> pastelColors = [];

  @override
  void initState() {
    super.initState();
    generatePastelColors();
  }

  void generatePastelColors() {
    final random = Random();
    for (int i = 0; i < 20; i++) {
      int red = 200 + random.nextInt(56); // 200-255
      int green = 200 + random.nextInt(56); // 200-255
      int blue = 200 + random.nextInt(56); // 200-255
      pastelColors.add(Color.fromRGBO(red, green, blue, 1));
    }
  }

  Color generateRandomPastelColor() {
    final random = Random();
    int index = random.nextInt(pastelColors.length);
    return pastelColors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Set your Time done into the input',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              TextForm(
                hintText: 'Hours',
                onChanged: (int value) {
                  setState(() => hour = value);
                },
              ),
              const SizedBox(height: 10),
              TextForm(
                hintText: 'Minutes',
                onChanged: (int value) {
                  setState(() => minute = value);
                },
              ),
              const SizedBox(height: 10),
              if (_canBuildSubmitForm())
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      style: const TextStyle(fontWeight: FontWeight.w800),
                      _buildSumTime(times: savedRegister),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          return _submitForm();
                        }
                      },
                      icon: CircleAvatar(
                        backgroundColor: generateRandomPastelColor(),
                        radius: 30,
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              if (savedRegister.isNotEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height * .65,
                  child: ListView.builder(
                    itemCount: savedRegister.length,
                    itemBuilder: (context, index) {
                      savedRegister.reversed;
                      return Card(
                        borderOnForeground: false,
                        color: Colors.white,
                        elevation: 3,
                        child: ListTile(
                          trailing: CircleAvatar(
                            backgroundColor: generateRandomPastelColor(),
                            radius: 15,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hours: ${savedRegister[index].hour.toString()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 14),
                              ),
                              Text(
                                'Minutes: ${savedRegister[index].minute.toString()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _canBuildSubmitForm() {
    return minute != null && hour != null;
  }

  Time createTime() {
    return Time(
      hour: hour!,
      minute: minute!,
    );
  }

  void _submitForm() {
    setState(() {
      Time task = createTime();
      savedRegister.add(task);
    });
  }

  String _buildSumTime({required List<Time> times}) {
    int totalMinutes = 0;
    int totalHours = 0;

    for (var time in times) {
      totalMinutes += time.minute;
      totalHours += time.hour;
    }

    if (totalMinutes % 60 == 0) {
      totalHours += totalMinutes ~/ 60;
      totalMinutes = totalMinutes % 60;
    }

    return '$totalHours horas y $totalMinutes minutos';
  }
}
