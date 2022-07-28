import 'package:algoriza_task/models/task.dart';
import 'package:algoriza_task/theme/theme.dart';
import 'package:algoriza_task/ui/home_page.dart';
import 'package:algoriza_task/ui/widgets/task_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../ui/widgets/input_field.dart';

class AddTaskScreen extends StatefulWidget {
  final List<Task> taskList;

  const AddTaskScreen(Map<List<Task>, List<Task>> map,
      {Key? key, required this.taskList})
      : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _selectedDate = DateTime.now();

  String _endTime = "14:00 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 20, 30, 60];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                title: "Title",
                hint: "Enter title",
                controller: _titleController,
              ),
              InputField(
                title: "Deadline",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDatePicker();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start time",
                      hint: startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimePicker(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimePicker(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: _selectedRemind.toString() + " minutes early",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) => {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    })
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) => {
                    setState(() {
                      _selectedRepeat = newValue!;
                    })
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TaskButton(
                label: "Create Task",
                onTap: () async {
                  await _createTask();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text("Add Task"),
      actions: const [
        Icon(
          Icons.person,
          size: 20,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _createTask() async {
    var task = Task(
      title: _titleController.text,
      deadline: DateFormat.yMd().format(_selectedDate),
      startTime: startTime,
      endTime: _endTime,
      reminder: _selectedRemind,
      repeat: _selectedRepeat,
      isCompleted: 0,
    );
    widget.taskList.addNonNull(task);
    await Get.to(() => const HomePage());
  }

  _getDatePicker() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("something went wrong!");
    }
  }

  _getTimePicker({required bool isStartTime}) async {
    var _pickerTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(startTime.split(":")[0]),
          minute: int.parse(startTime.split(":")[1].split(" ")[0])),
    );
    String picked = _pickerTime!.format(context);

    if (_pickerTime == null) {
      print("time cancelled");
    } else if (isStartTime) {
      setState(() {
        startTime = picked;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = picked;
      });
    }

    // if (_pickerTime != null) {
    //   setState(() {
    //     _selectedDate = _pickerDate;
    //   });
    // } else {
    //   print("something went wrong!");
    // }
  }
}
