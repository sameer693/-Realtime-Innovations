import 'package:employee_manager/model/employee.dart';
import 'package:employee_manager/views/add_emp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../cubits/employee_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<EmployeeCubit>().loadEmployees();
    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            final curEmployees = state.curEmployees;
            final prevEmployees = state.prevEmployees;

            if (curEmployees.isEmpty && prevEmployees.isEmpty) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                  child:
                      Image.asset("assets/noemployee.png", fit: BoxFit.contain),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (curEmployees.isNotEmpty)
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: ListTile(
                          tileColor: Colors.grey.shade300,
                          title: Text(
                            "Current Employees",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )),
                  ListView.builder(
                    itemCount: curEmployees.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final emp = curEmployees[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                context
                                    .read<EmployeeCubit>()
                                    .deleteEmployee(emp.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Employee data has been deleted"),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              backgroundColor: Colors.red,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(emp.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(emp.role),
                                Text(
                                    "From ${DateFormat('d MMM, yyyy').format(emp.startDate)}"),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<EmployeeCubit>(),
                                    child: AddEditEmployeePage(employee: emp),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  if (prevEmployees.isNotEmpty)
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: ListTile(
                          tileColor: Colors.grey.shade300,
                          title: Text(
                            "Previous Employees",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )),
                  ListView.builder(
                    itemCount: prevEmployees.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final emp = prevEmployees[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                context
                                    .read<EmployeeCubit>()
                                    .deleteEmployee(emp.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Employee data has been deleted"),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              backgroundColor: Colors.red,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(emp.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(emp.role),
                                Text(
                                    "${DateFormat('d MMM, yyyy').format(emp.startDate)} - ${DateFormat('d MMM, yyyy').format(emp.endDate!)}"),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<EmployeeCubit>(),
                                    child: AddEditEmployeePage(employee: emp),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Icon(Icons.error),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<EmployeeCubit>(),
                child: AddEditEmployeePage(),
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar:
          BlocBuilder<EmployeeCubit, EmployeeState>(builder: (context, state) {
        if (state is EmployeeLoading) {
          return const SizedBox.shrink();
        } else if (state is EmployeeLoaded) {
          final List<Employee> curEmployees = state.curEmployees;
          final List<Employee> prevEmployees = state.prevEmployees;
          return curEmployees.isNotEmpty || prevEmployees.isNotEmpty
              ? BottomAppBar(
                  child: Text(
                    "Swipe left to delete",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : const SizedBox.shrink();
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
