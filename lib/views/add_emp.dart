import 'package:employee_manager/model/employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../cubits/employee_cubit.dart';

class AddEditEmployeePage extends StatefulWidget {
  final Employee? employee;
  const AddEditEmployeePage({super.key, this.employee});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<String> _roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner',
  ];
  String? _selectedRole;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;
      _startDate = widget.employee!.startDate;
      _endDate = widget.employee!.endDate;
    }
  }

  void _selectRole() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: _roles.map((role) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _selectedRole = role);
              Navigator.pop(context);
            },
            child: Text(
              role,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final newEmployee = Employee(
        id: widget.employee?.id,
        name: _nameController.text,
        role: _selectedRole!,
        startDate: _startDate!,
        endDate: _endDate,
      );
      if (widget.employee == null) {
        context.read<EmployeeCubit>().addEmployee(newEmployee);
      } else {
        context.read<EmployeeCubit>().updateEmployee(newEmployee);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
        actions: [
          if (widget.employee != null)
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                context
                    .read<EmployeeCubit>()
                    .deleteEmployee(widget.employee!.id!);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Name cannot be empty"
                      : null,
                ),
                GestureDetector(
                  onTap: _selectRole,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(text: _selectedRole),
                      decoration: InputDecoration(
                        labelText: "Role",
                        hintText: _selectedRole ?? "Select a role",
                        prefixIcon:
                            Icon(Icons.work_outline, color: Colors.blue),
                        suffixIcon: const Icon(Icons.arrow_drop_down,
                            color: Colors.blue),
                      ),
                      validator: (value) =>
                          _selectedRole == null ? "Please select a role" : null,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            controller: TextEditingController(
                              text: _startDate != null
                                  ? DateFormat('d MMM yyyy').format(_startDate!)
                                  : "",
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: Colors.blue),
                              // labelText: "Start Date",
                              hintText: _startDate != null
                                  ? DateFormat('d MMM yyyy').format(_startDate!)
                                  : "No Date",
                            ),
                            validator: (value) {
                              if (_startDate == null) {
                                return "Please select a start date";
                              }
                              // Only validate the relationship if an end date is provided
                              if (_endDate != null &&
                                  !_endDate!.isAfter(_startDate!)) {
                                return "End date must be after start date";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward, color: Colors.blue),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            controller: TextEditingController(
                                text: _endDate != null
                                    ? DateFormat('d MMM yyyy').format(_endDate!)
                                    : "No Date"),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: Colors.blue),
                              // labelText: "No Date",
                              hintText: _endDate != null
                                  ? DateFormat('d MMM yyyy').format(_endDate!)
                                  : "No Date",
                            ),
                            validator: (value) {
                              // Since end date is optional, only validate if a date is provided.
                              if (_endDate != null && _startDate != null) {
                                if (!_endDate!.isAfter(_startDate!)) {
                                  // Optionally, show an error via a SnackBar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "End date must be after start date"),
                                    ),
                                  );
                                  return "End date must be after start date";
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () => _saveEmployee(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper function to compute the next occurrence of a given weekday.
  DateTime _getNextWeekday(DateTime fromDate, int weekday) {
    // In Dart, Monday is 1 and Sunday is 7.
    int daysToAdd = ((weekday - fromDate.weekday) + 7) % 7;
    if (daysToAdd == 0) {
      daysToAdd = 7; // if the desired weekday is today, jump to next week.
    }
    return fromDate.add(Duration(days: daysToAdd));
  }

  void _selectDate(BuildContext context, bool isStart) {
    final currentDate = isStart
        ? _startDate ?? DateTime.now()
        : _endDate ?? _startDate ?? DateTime.now();
    DateTime focusDate = currentDate;
    final List<Map<String, dynamic>> dateOptions = isStart
        ? [
            {
              'label': 'Today',
              'date': DateTime.now(),
            },
            {
              'label': 'Next Monday',
              'date': _getNextWeekday(DateTime.now(), DateTime.monday),
            },
            {
              'label': 'Next Tuesday',
              'date': _getNextWeekday(DateTime.now(), DateTime.tuesday),
            },
            {
              'label': 'After 1 Week',
              'date': DateTime.now().add(const Duration(days: 7)),
            },
          ]
        : [
            {
              'label': 'No Date',
              'date': null,
            },
            {
              'label': 'Today',
              'date': DateTime.now(),
            },
          ];
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: StatefulBuilder(builder: (context, set) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isStart ? 'Select Start Date' : 'Select End Date'),
                  GridView.builder(
                    // Use shrinkWrap to let GridView take minimal space
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    // Adjust grid layout based on options; for example, 2 columns for start dates, 1 for non-start.
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio:
                          3, // Adjust as needed for button height/width
                    ),
                    itemCount: dateOptions.length,
                    itemBuilder: (context, index) {
                      final option = dateOptions[index];
                      return ElevatedButton(
                        onPressed: () {
                          final DateTime? selectedDate = option['date'];
                          setState(() {
                            if (isStart) {
                              _startDate = selectedDate;
                            } else {
                              _endDate = selectedDate;
                            }
                          });
                          set(() {
                            focusDate = selectedDate ?? DateTime.now();
                          });
                          // Optionally, pop a dialog or notify the parent widget.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          option['label'],
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                  TableCalendar(
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronMargin:
                          EdgeInsets.only(left: 20), // Bring chevrons closer
                      rightChevronMargin:
                          EdgeInsets.only(right: 20), // Bring chevrons closer
                      leftChevronPadding: EdgeInsets.zero,
                      rightChevronPadding: EdgeInsets.zero,
                      leftChevronIcon: Icon(Icons.arrow_left, size: 48),
                      rightChevronIcon: Icon(Icons.arrow_right, size: 48),
                    ),
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: focusDate,
                    selectedDayPredicate: (day) =>
                        (isStart && isSameDay(_startDate, day)) ||
                        (!isStart && isSameDay(_endDate, day)),
                    rangeStartDay: _startDate,
                    rangeEndDay: _endDate,
                    rangeSelectionMode: RangeSelectionMode.toggledOn,
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      rangeHighlightColor: Colors.blue.withOpacity(0.2),
                      rangeStartDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue.shade900, width: 2),
                      ),
                      rangeEndDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        if (isStart) {
                          _startDate = selectedDay;
                        } else {
                          _endDate = selectedDay;
                        }
                        focusDate = selectedDay;
                      });
                      set(() {});
                    },
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Row(
                        spacing: 1,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          Text(
                            isStart
                                ? (_startDate != null
                                    ? DateFormat('d MMM yyyy').format(_startDate!)
                                    : "No Date")
                                : (_endDate != null
                                    ? DateFormat('d MMM yyyy').format(_endDate!)
                                    : "No Date"),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
